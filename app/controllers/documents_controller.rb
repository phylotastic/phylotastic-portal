class DocumentsController < ApplicationController
  def new
    @document = Document.new
  end

  def create
    @document = current_or_guest_user.documents.build(document_params)
    if @document.save
      name = params[:name].empty? ? @document.file.original_filename : params[:name]
      @list = @document.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"

      file = File.new(@document.file.path, 'rb')
      
      if @document.method == "NetiNeti"
        method = 2
      elsif @document.method == "TaxonFinder"
        method = 1
      else
        method = 0
      end
      
      extracted_response = Req.post(Rails.configuration.x.sv_GNRD_wrapper_file,
                                    { 
                                      multipart: true,
                                      inputFile: file,
                                      engine: method
                                    },
                                    {} )
                                    
      @list.update_attributes(extracted: extracted_response.to_json)
      
      resolved_response = Req.post( Rails.configuration.x.sv_OToL_TNRS_wrapper,
                                    extracted_response.to_json,
                                    :content_type => :json )

      if resolved_response.empty?
        extracted_for_gnr = extracted_response
        extracted_for_gnr["fuzzy_match"]    = true
        extracted_for_gnr["multiple_match"] = false
        resolved_response = Req.post( Rails.configuration.x.sv_GNR_TNRS_wrapper,
                                      extracted_for_gnr.to_json,
                                      :content_type => :json )
      end
      
      if resolved_response.empty?
        error = Req.post( Rails.configuration.x.sv_OToL_TNRS_wrapper,
                          extracted_response.to_json,
                          {:content_type => :json},
                          true )
        fail_record = Failure.last.id
      end     

      @list.update_attributes(resolved: resolved_response.to_json, 
                              resolving_error: error, 
                              possible_failure_record: fail_record)   

      
      redirect_to list_path(@list)
    else
      render action: "new"
    end
  end
  
  private
  
    def document_params
      params.require(:document).permit(:file, :method)
    end
end
