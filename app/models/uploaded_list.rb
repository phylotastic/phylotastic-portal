require 'csv'
require 'roo'

class UploadedList < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :file
  validates_attachment :file, presence: true,
    content_type: { content_type: "application/zip", :message => ": Make sure to zip your files" },
    size: { in: 0..500.kilobytes, :message => "must be less than 500kB" }
    
  def self.process(user_name, user_id, file)
    spreadsheet = self.open_spreadsheet(file)
    header = spreadsheet.row(1)
    
    data = {}
    data["is_list_public"] = false
    data["list_origin"] = "webapp"
    data["list_keywords"] = []
    data["list_author"] = []
    data["list_species"] = [
      {"family"=>"",
      "scientific_name"=>"Aix sponsa",
      "scientific_name_authorship"=>"",
      "vernacular_name"=>"Wood Duck",
      "phylum"=>"",
      "nomenclature_code"=>"ICZN",
      "order"=>"Anseriformes"},
     {"family"=>"",
      "scientific_name"=>"Anas strepera",
      "scientific_name_authorship"=>"",
      "vernacular_name"=>"Gadwall",
      "phylum"=>"",
      "nomenclature_code"=>"ICZN",
      "order"=>"Anseriformes"}]
    
    # list details
    if header.include?("List Title")
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]    
        row.each do |k,v|
          case k
          when "List Author"
            row[k].split(',').each { |w| data["list_author"] << w }
          when "Curation Date"
            data["list_curation_date"] = row[k].to_date.strftime("%m-%d-%Y")
          when "Curator"
            data["list_curator"] = row[k]
          when "Date published"
            data["list_date_published"] = row[k].to_date.strftime("%m-%d-%Y")
          when "Description"
            data["list_description"] = row[k]
          when "extra info"
            data["list_extra_info"] = row[k]
          when "Focal clade"
            data["list_focal_clade"] = row[k]
          when "Keywords"
            row[k].split(',').each { |w| data["list_keywords"] << w }
          when "Source"
            data["list_source"] = row[k]
          when "List Title"
            data["list_title"] = row[k]
          when "Source"
            data["list_source"] = row[k]
          end
        end
        puts row
      end
      
    # species details
    elsif header.include?("vernacularName")
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        # data[:list_species] 
      end
    end
    
    response = Req.post( APP_CONFIG["sv_createlist"]["url"],
                         { "user_name" => user_name, 
                           "user_id" => user_id,
                           "list" => data
                         }.to_json,
                         {:content_type => :json} )
    
    binding.pry
    
  end

  def self.open_spreadsheet(file)
    case File.extname(File.basename(file))
    when ".csv" then Roo::CSV.new(file.path, csv_options: {col_sep: ","})
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{File.basename(file)}"
    end
  end
  
  def self.extraction_location(f_path, entry_name)
    File.dirname(f_path) + "/#{entry_name}"
  end
end
