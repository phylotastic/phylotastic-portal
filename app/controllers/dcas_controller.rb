require 'zip'

class DcasController < ApplicationController
  before_action :authenticate_user!, :except => [:new, :create]

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
          data["list_species"] = []
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
  
  def publish
    @dca = current_or_guest_user.dcas.find(params[:id])
    
    if @dca.nil?
      redirect_to root_path
      return
    end
    
    list_data = Dca.process(@dca)
    list_data["is_list_public"] = true
    data = {}
    data["user_id"] = current_user.email
    data["list"] = list_data
    response = Req.post( Rails.configuration.x.sv_Add_new_list,
                         data.to_json,
                         {:content_type => :json},
                         true )
                         
    if response.empty?
      flash[:alert] = "Please try again later, there is problem publishing your list."
    elsif response.class.to_s == "RestClient::Response"
      flash[:alert] = JSON.parse(response.body)["message"]
    else
      flash[:notice] = "Your list is public now. Thank you for your contribution."
      @dca.update_attributes(publish_list_id: response["list_id"])
    end
    redirect_to list_path(@dca.list)
    # {
#       "user_id": "hdail.laughinghouse@gmail.com",
#       "list": {
#         "list_extra_info": "",
#         "list_description": "A list of the bird species and their endangered, threatened or invasive status",
#         "list_keywords": ["Bird", "Endangered species", "Everglades"],
#         "list_curator": "HD Laughinghouse",
#         "list_origin": "script",
#         "list_curation_date": "02-24-2016",
#         "list_source": "Des",
#         "list_focal_clade": "Aves",
#         "list_title": "Bird Species List for Everglades National Park",
#         "list_author": ["Bass, O.", "Cunningham, R."],
#         "is_list_public": true,
#         "list_species": [
#           {
#             "family": "Anatidae",
#             "scientific_name": "Aix sponsa",
#             "vernacular_name": "Wood Duck",
#             "nomenclature_code": "ICZN",
#             "order": "Anseriformes"
#           },
#           {
#             "family": "Anatidae",
#             "scientific_name":
#             "Anas strepera",
#             "vernacular_name": "Gadwall",
#             "nomenclature_code": "ICZN",
#             "order": "Anseriformes"
#           },
#           {
#             "family": "Caprimulgidae",
#             "scientific_name": "Caprimulgus vociferus",
#             "scientific_name_authorship": "",
#             "vernacular_name": "Whip-poor-will",
#             "nomenclature_code": "ICZN",
#             "order": "Caprimulgiformes"
#           }
#         ]
#       }
#     }
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
