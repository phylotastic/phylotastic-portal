class OnplsController < ApplicationController
  def new
    @onpl = Onpl.new
  end

  def create
    @onpl = current_or_guest_user.onpls.build(onpl_params)
    if @onpl.save
      name = params[:name].empty? ? @onpl.file.original_filename : params[:name]
      @list = @onpl.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"

      extracted_response = {}
      extracted = Paperclip.io_adapters.for(@onpl.file).read.split("\n")
      extracted_response["scientificNames"] = extracted.map do |n|
        n.to_s.strip.encode('UTF-8', {
          :invalid => :replace,
          :undef   => :replace,
          :replace => '?'
        })
      end
      
      @list.update_attributes(extracted: extracted_response.to_json)
      
      resolved_response = Req.post( Rails.configuration.x.sv_OToL_TNRS_wrapper,
                                    extracted_response.to_json,
                                    :content_type => :json )
      
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
  
    def onpl_params
      begin
        params.require(:onpl).permit(:file)
      rescue
        {}
      end
    end
end
