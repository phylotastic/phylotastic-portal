class LinksController < ApplicationController
  def new
    @link = Link.new
  end

  def create
    @link = current_or_guest_user.links.build(link_params)
    if @link.save
      name = params[:name].empty? ? link_params[:url] : params[:name]
      # binding.pry
      @list = @link.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"
      
      extracted_response = Req.get(Rails.configuration.x.sv_GNRD_wrapper_URL + @link.url)
      @list.update_attributes(extracted: extracted_response)
      
      resolved_response = Req.post( Rails.configuration.x.sv_OToL_TNRS_wrapper,
                                    extracted_response.to_json,
                                    :content_type => :json )
                                  
      @list.update_attributes(resolved: resolved_response)
      
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
