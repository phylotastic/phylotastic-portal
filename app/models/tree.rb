class Tree < ApplicationRecord
  belongs_to :user
  
  has_attached_file :image, styles: { large: "800x600>", medium: "400x300>", thumb: "120x90>" }, default_url: "/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
  def unscaled
    begin
      JSON.parse(Tree.first.tree)["newick"]
    rescue
      []
    end
  end
  
  def scaled_sdm
    begin
      JSON.parse(Tree.first.scaled_sdm)["newick"]
    rescue
      []
    end
  end
end
