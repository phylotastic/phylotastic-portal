class Tree < ApplicationRecord
  include ListsHelper
  
  belongs_to :user
  
  has_attached_file :image, styles: { large: "800x600>", medium: "400x300>", thumb: "120x90>" }, default_url: "/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
  def common_name_tips
    # get tree from public list
    if self.list.nil?
      if self.common_name_mapping.nil?
        list = get_a_list_from_service(self.list_id)
        req = {}
        req["result"] = {}
        req["result"]["tip_list"] = []
        tip_list = list["list"]["list_species"].map do |r|
          a = {}
          a["common_name"] = r["vernacular_name"].empty? ? [""] : [r["vernacular_name"]]
          a["scientific_names"] = [r["scientific_name"]]
          b = {}
          b["common_names"] = r["vernacular_name"].empty? ? [""] : [r["vernacular_name"]]
          b["scientific_name"] = r["scientific_name"]
          req["result"]["tip_list"].append(b)
          a
        end
        self.update_attributes(common_name_mapping: req.to_json)
        return {"tip_list": tip_list}
      else
        return convert_common_name
      end
    end
    
    resource = self.list.resource
    case resource.class.name
    when "Cn"
      begin
        common_name_mapping = JSON.parse(resource.common_name_mapping)
        tip_list = common_name_mapping["result"].map do |r|
          a = {}
          a["common_name"] = [r["searched_name"]]
          a["scientific_names"] = r["matched_names"].map {|b| b["scientific_name"]}
          a
        end
        return {"tip_list": tip_list}
      rescue
        return {"tip_list": []}
      end
    when "Dca"
      # TODO
      return {"tip_list": []}
    else
      if self.common_name_mapping.nil?
        return {"tip_list": []}
      else
        return convert_common_name
      end
    end
  end
  
  def convert_common_name
    begin
      mapping = JSON.parse(self.common_name_mapping)
      tip_list = mapping["result"]["tip_list"].map do |r|
        a = {}
        a["common_name"] = r["common_names"]
        a["scientific_names"] = r["scientific_name"].nil? ? [] : [r["scientific_name"]]
        a
      end
      return {"tip_list": tip_list}
    rescue
      return {"tip_list": []}
    end
  end
  
  def unscaled
    begin
      n = JSON.parse(self.tree)["newick"]
      return n.nil? ? "" : n 
    rescue
      ""
    end
  end
  
  def sdm_scaled
    begin
      n = JSON.parse(self.scaled_sdm)["scaled_tree"]
      return n.nil? ? "" : n 
    rescue
      ""
    end
  end
  
  def median_scaled
    begin
      n = JSON.parse(self.scaled_median)["scaled_tree"]
      return n.nil? ? "" : n 
    rescue
      ""
    end
  end
  
  def ot_scaled
    begin
      n = JSON.parse(self.scaled_ot)["scaled_tree"]
      return n.nil? ? "" : n 
    rescue
      ""
    end
  end
  
  def metadata
    begin
      n = JSON.parse(self.tree)["tree_metadata"]
      return n.nil? ? "" : n 
    rescue
      ""
    end
  end
  
  def chosen_species
    species = JSON.parse(self.species) rescue {}
    chosen_species = species.select { |x| species[x] == "1" }.keys
    return chosen_species
  end
  
  def list
    unless self.list_from_service
      @list = List.find(self.list_id)
    end
  end
  
  def self.of_service_list(list_id)
    Tree.where(list_id: list_id, list_from_service: true)
  end
  
end
