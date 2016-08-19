class ConTaxon < ActiveRecord::Base
  actable
  
  belongs_to :user
  has_one :raw_extraction, as: :contributable, dependent: :destroy
  belongs_to :country
  
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :name, presence: true
  
  def meta_origin
    taxon
  end
  
end
