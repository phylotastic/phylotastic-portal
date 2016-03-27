require 'csv'
require 'roo'

class UploadedList < ActiveRecord::Base
  belongs_to :user
  has_one :raw_extraction, as: :contributable, dependent: :destroy
  
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
            data["list_curation_date"] = parse_date(row[k])
          when "Curator"
            data["list_curator"] = val
          when "Date published"
            data["list_date_published"] = parse_date(row[k])
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
          when "Source"
            data["list_source"] = val
          end
        end
      # species details
      elsif header.include?("vernacularName")
        (2..spreadsheet.last_row).each do |i|
          s_data = {}
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

    response = Req.post( APP_CONFIG["sv_createlist"]["url"],
                         { "user_name" => user_name, 
                           "user_id" => user_id,
                           "list" => data
                         }.to_json,
                         {:content_type => :json} )

    if !response || JSON.parse(response)["status_code"] != 200
      ul.update_attributes(status: false)
    else
      ul.update_attributes(status: true, lid: JSON.parse(response)["list_id"])
      # create a raw extraction
      t = data["list_species"].map {|s| s["scientific_name"]}.join(", ")
      found = Req.get( APP_CONFIG["sv_findnamesintext"]["url"] + t )
      resolved = Req.post( APP_CONFIG["sv_resolvenames"]["url"], found, :content_type => :json)
      extraction = ul.create_raw_extraction(species: resolved)
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
  
  def self.parse_date(d)
    if d.nil?
      ""
    elsif d.length == 4
      "01-01-#{d}"
    elsif d.length < 10
      (d.to_date + 2000.years).strftime("%m-%d-%Y")
    else
      d.to_date.strftime("%m-%d-%Y")
    end
  end
end
