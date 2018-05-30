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
end
