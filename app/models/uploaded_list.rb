require 'csv'
require 'roo'

class UploadedList < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :file
  validates_attachment :file, presence: true,
    content_type: { content_type: "application/zip", :message => ": Make sure to zip your files" },
    size: { in: 0..500.kilobytes, :message => "must be less than 500kB" }
    
  def self.process(user_name, user_id, ul_id)
    ul = UploadedList.find(ul_id)
    dir = File.dirname(ul.file.path)
    data = {}
    data["is_list_public"] = ul.public
    data["list_origin"] = "webapp"
    data["list_keywords"] = []
    data["list_author"] = []
    data["list_species"] = []
    
    Dir.glob(dir + '/**/*') do |file|
      spreadsheet = self.open_spreadsheet(File.open(file))
      if spreadsheet.nil?
        next
      end
      header = spreadsheet.row(1)

      # list details
      if header.include?("List Title")
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]    
          row.each_key do |k|
            row[k].strip!.lowercase!
            case k
            when "List Author"
              row[k].split(',').each { |w| data["list_author"] << w }
            when "Curation Date"
              if row[k].nil?
                data["list_curation_date"] = ""
              elsif row[k].length == 4
                data["list_curation_date"] = row[k]
              else
                data["list_curation_date"] = row[k].to_date.strftime("%m-%d-%Y")
              end
            when "Curator"
              data["list_curator"] = row[k].nil? ? "" : row[k]
            when "Date published"
              if row[k].nil?
                data["list_curation_date"] = ""
              elsif row[k].length == 4
                data["list_curation_date"] = row[k]
              else
                data["list_date_published"] = row[k].to_date.strftime("%m-%d-%Y")
              end
            when "Description"
              data["list_description"] = row[k].nil? ? "" : row[k]
            when "extra info"
              data["list_extra_info"] = row[k].nil? ? "" : row[k]
            when "Focal clade"
              data["list_focal_clade"] = row[k].nil? ? "" : row[k]
            when "Keywords"
              unless row[k].nil?
                row[k].split(',').each { |w| data["list_keywords"] << w }
              end
            when "Source"
              data["list_source"] = row[k].nil? ? "" : row[k]
            when "List Title"
              data["list_title"] = row[k].nil? ? "" : row[k]
            when "Source"
              data["list_source"] = row[k].nil? ? "" : row[k]
            end
          end
        end
      
      # species details
      elsif header.include?("vernacularName")
        (2..spreadsheet.last_row).each do |i|
          s_data = {}
          row = Hash[[header, spreadsheet.row(i)].transpose]
          row.each_key do |k|
            row[k].strip!.lowercase!
            case k
            when "vernacularName"
              s_data["vernacular_name"] = row[k].nil? ? "" : row[k]
            when "scientificName"
              s_data["scientific_name"] = row[k].nil? ? "" : row[k]
            when "scientificNameAuthorship"
              s_data["scientific_name_authorship"] = row[k].nil? ? "" : row[k]
            when "Phylum"
              s_data["phylum"] = row[k].nil? ? "" : row[k]
            when "Family"
              s_data["family"] = row[k].nil? ? "" : row[k]
            when "Order"
              s_data["order"] = row[k].nil? ? "" : row[k]
            when "nomenclaturalCode"
              s_data["nomenclature_code"] = row[k].nil? ? "" : row[k]
            end
          end
          data["list_species"] << s_data
        end
      end
    end
    
    response = Req.post( APP_CONFIG["sv_createlist"]["url"],
                         { "user_name" => user_name, 
                           "user_id" => user_id,
                           "list" => data
                         }.to_json,
                         {:content_type => :json} )

    if !response || JSON.parse(response)["status_code"] != 200
      ul.update_attributes(status: false)
    else
      ul.update_attributes(status: true)
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(File.basename(file))
    when ".csv" then Roo::CSV.new(file.path, csv_options: {col_sep: ","})
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else 
      # raise "Unknown file type: #{File.basename(file)}"
    end
  end
  
  def self.extraction_location(f_path, entry_name)
    File.dirname(f_path) + "/#{entry_name}"
  end
end
