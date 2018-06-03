require 'csv'
require 'roo'

class Dca < ApplicationRecord
  belongs_to :user
  
  has_one :list, as: :resource, dependent: :destroy
  
  has_attached_file :file, default_url: "/images/:style/missing.png"
  
  default_scope -> { order(created_at: :desc) }
  
  validates_attachment :file, 
    content_type: { content_type: "application/zip", :message => ": Make sure to zip your files" },
    size: { in: 0..500.kilobytes, :message => "must be less than 500kB" }

  validates_attachment_presence :file
  
  def self.process(ul)
    dir = File.dirname(ul.file.path)
    data = {}
    data["is_list_public"] = false
    data["list_origin"] = "webapp"
    data["list_keywords"] = []
    data["list_author"] = []
    data["list_species"] = []
    data["list_curation_date"] = nil
    data["list_curator"] = nil
    data["list_date_published"] = nil
    data["list_description"] = nil
    data["list_extra_info"] = nil
    data["list_focal_clade"] = nil
    data["list_source"] = nil
    data["list_title"] = nil
    
    Dir.glob(dir + '/**/*') do |file|
      spreadsheet = self.open_spreadsheet(File.open(file))
      if spreadsheet.nil?
        next
      end

      begin
        header = spreadsheet.row(1)
      rescue ArgumentError => e
        # ul.update_attributes(status: false, reason: e.message)
        puts e.message
        return
      end

      # list details
      if header.include?("List Title")
        # only read the second line
        row = Hash[[header, spreadsheet.row(2)].transpose]    
        row.each_key do |k|
          if row[k].nil?
            val = ""
          else 
            row[k].strip! 
            val = row[k].strip
          end
          
          case k
          when "List Author"
            row[k].split(',').each { |w| data["list_author"] << w }
          when "Curation Date"
            if parse_date(row[k])
              data["list_curation_date"] = parse_date(row[k])
            else
              # ul.update_attributes(status: false, reason: "#{row[k]} is not in YYYY-MM-DD format")
              puts "#{row[k]} is not in YYYY-MM-DD format"
              return
            end
          when "Curator"
            data["list_curator"] = val
          when "Date published"
            if parse_date(row[k])
              data["list_date_published"] = parse_date(row[k])
            else
              # ul.update_attributes(status: false, reason: "#{row[k]} is not in YYYY-MM-DD format")
              puts "#{row[k]} is not in YYYY-MM-DD format"
              return
            end
          when "Description"
            data["list_description"] = val
          when "extra info"
            data["list_extra_info"] = val
          when "Focal clade"
            data["list_focal_clade"] = val
          when "Keywords"
            unless row[k].nil?
              row[k].split(',').each { |w| data["list_keywords"] << w }
            end
          when "Source"
            data["list_source"] = val
          when "List Title"
            data["list_title"] = val
          end
        end
        
      # species details
      elsif header.include?("vernacularName")
        (2..spreadsheet.last_row).each do |i|
          s_data = {}
          s_data["vernacular_name"] = nil
          s_data["scientific_name"] = nil
          s_data["scientific_name_authorship"] = nil
          s_data["phylum"] = nil
          s_data["family"] = nil
          s_data["order"] = nil
          s_data["class"] = nil
          s_data["nomenclature_code"] = nil
          
          row = Hash[[header, spreadsheet.row(i)].transpose]
          row.each_key do |k|
            val = row[k].nil? ? "" : row[k].strip
            case k
            when "vernacularName"
              s_data["vernacular_name"] = val
            when "scientificName"
              s_data["scientific_name"] = val
            when "scientificNameAuthorship"
              s_data["scientific_name_authorship"] = val
            when "Phylum"
              s_data["phylum"] = val
            when "Family"
              s_data["family"] = val
            when "Class"
              s_data["class"] = val
            when "Order"
              s_data["order"] = val
            when "nomenclaturalCode"
              s_data["nomenclature_code"] = val
            end
          end
          data["list_species"] << s_data
        end
      end
    end

    # response = Req.post( APP_CONFIG["sv_create_list"]["url"],
    #                      { "user_id" => user_name,
    #                        "list" => data
    #                      }.to_json,
    #                      {:content_type => :json} )
                         
    # if response.empty? || JSON.parse(response)["status_code"] != 200
    #   ul.update_attributes(status: false, reason: JSON.parse(response)["message"])
    #   return {}
    # else
    #   ul.update_attributes(status: true, lid: JSON.parse(response)["list_id"])
    #   # create a raw extraction
    #   t = data["list_species"].map {|s| s["scientific_name"]}.join(", ")
    #   found = Req.get( APP_CONFIG["sv_find_names_in_text"]["url"] + t )
    #   return found
    # end
    
    return data
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
    
  def self.parse_date(d)
    if d.nil?
      ""
    elsif d == "NA"
      "NA"
    else
      begin
        date = Date.parse(d).to_s
      rescue ArgumentError
        logger.info "#{d} can not be parsed"
        false
      end
    end
  end
  
  def meta_origin
    file.original_filename
  end
end
