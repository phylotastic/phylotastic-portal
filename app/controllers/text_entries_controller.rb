class TextEntriesController < ApplicationController
  def new
    @text_entry = TextEntry.new
  end

  def create
    @text_entry = current_or_guest_user.text_entries.build(text_entry_params)
    if @text_entry.save
      name = params[:name].empty? ? "Text entry" : params[:name]

      @list = @text_entry.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"
      
      entry = text_entry_params["corpus"].gsub("\n", " ")
      extracted_response = Req.get( Rails.configuration.x.sv_GNRD_wrapper_text + entry )
      
      if extracted_response.empty?
        extracted_response = Req.get(Rails.configuration.x.sv_TaxonFinder_wrapper_text + entry)
      end
      
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
  
    def text_entry_params
      params.require(:text_entry).permit(:corpus)
    end
    
end
