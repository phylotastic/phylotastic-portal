class CnsController < ApplicationController
  def new
    @cn = Cn.new
  end
  
  def create
    @cn = current_or_guest_user.cns.build(cn_params)
    if @cn.save
      name = params[:name].empty? ? @cn.file.original_filename : params[:name]
      @list = @cn.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"

      loaded_from_file = {}
      raw = Paperclip.io_adapters.for(@cn.file).read.split("\n")
      loaded_from_file["commonnames"] = raw.map do |n|
        n.to_s.strip.encode('UTF-8', {
          :invalid => :replace,
          :undef   => :replace,
          :replace => '?'
        })
      end
      
      loaded_from_file["multiple_match"] = @cn.multiple_match
      
      mapping_response = {}
      mapping_response = Req.post( Rails.configuration.x.sv_NCBI_common_name,
                                   loaded_from_file.to_json,
                                   :content_type => :json )
      if mapping_response.empty?
        mapping_response = Req.post( Rails.configuration.x.sv_ITIS_common_name,
                                     loaded_from_file.to_json,
                                     :content_type => :json )
      end

      if mapping_response.empty?
        mapping_response = Req.post( Rails.configuration.x.sv_TROPICOS_commmon_name,
                                     loaded_from_file.to_json,
                                     :content_type => :json )
      end
      
      extracted_response = {}
      begin 
        extracted_response["scientificNames"] = mapping_response["result"].map do |n|
          n["matched_names"].map do |m|
            m["scientific_name"]
          end
        end.flatten
      rescue
        extracted_response["scientificNames"] = []
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
  
    def cn_params
      begin
        params.require(:cn).permit(:file, :multiple_match)
      rescue
        {}
      end
    end
end
