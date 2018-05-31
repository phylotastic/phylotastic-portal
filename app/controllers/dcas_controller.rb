require 'zip'

class DcasController < ApplicationController
  def new
    @dca = Dca.new
  end

  def create
    @dca = current_or_guest_user.dcas.build(dca_params)
    data = {}
    if @dca.save
      name = @dca.file.original_filename
      @list = @dca.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"

      f_path = @dca.file.path
      Zip::File.open(f_path) do |zip_file|
        # Handle entries one by one
        zip_file.each do |entry|
          # Extract to file/directory/symlink
          puts "Extracting #{entry.name}"
          entry_path = File.dirname(f_path) + "/#{entry.name}"
          entry.extract(entry_path)
        end

        begin
          data = Dca.process(@dca)
        rescue Exception => e
          puts e
          puts e.backtrace
        end      
      end
      
      t = data["list_species"].map {|s| s["scientific_name"]}.join(", ")
      
      extracted_response = Req.get( Rails.configuration.x.sv_GNRD_wrapper_text + t )
      @list.update_attributes(extracted: extracted_response.to_json)
      
      resolved_response = Req.post( Rails.configuration.x.sv_OToL_TNRS_wrapper,
                                    extracted_response.to_json,
                                    :content_type => :json )
                                  
      @list.update_attributes(resolved: resolved_response.to_json)
      
      redirect_to list_path(@list)
    else
      render action: "new"
    end
  end
  
  private
  
    def dca_params
      begin
        params.require(:dca).permit(:file)
      rescue
        {}
      end
    end
end
