class Tree < ActiveRecord::Base
  belongs_to :user
  belongs_to :phylo_source
  belongs_to :raw_extraction 
  has_many :watch_relationships, dependent: :destroy
  has_many :followers, through: :watch_relationships, source: :user
  
  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  has_attached_file :image, styles: { medium: "400x300>", thumb: "120x90>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  self.per_page = 9
  
  searchable do
    text :chosen_species, :description
    boolean :public
  end
  
  def semantic_status
    case self.status
    when "resolved"
      return "Names acquired: click \"Check name list\" to approve list and get a tree"
    when "unsucessfully-resolved"
      return "Sorry! We could not acquire a list of names!"
    when "unsuccessfully-constructed"
      return "Sorry! We could not acquire a tree!"
    when "completed"
      return "Tree acquired: click \"View tree\" to see it"
    end
  end
  
end
