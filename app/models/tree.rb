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
end
