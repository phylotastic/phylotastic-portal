class Tree < ApplicationRecord
  belongs_to :user
  
  has_attached_file :image, styles: { large: "800x600>", medium: "400x300>", thumb: "120x90>" }, default_url: "/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
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
      n = JSON.parse(self.scaled_sdm)["newick"]
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
  
end
