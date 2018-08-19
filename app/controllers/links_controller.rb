class LinksController < ApplicationController
  def new
    @link = Link.new
  end

  def create
    @link = current_or_guest_user.links.build(link_params)
    if @link.save
      name = params[:name].empty? ? link_params[:url] : params[:name]

      @list = @link.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"
      
      extracted_response = Req.get(Rails.configuration.x.sv_GNRD_wrapper_URL + @link.url)
      
      if extracted_response.empty?
        extracted_response = Req.get(Rails.configuration.x.sv_TaxonFinder_wrapper_URL + @link.url)
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
  
    def link_params
      params.require(:link).permit(:url)
    end
    
end
