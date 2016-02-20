class ConTaxon < ActiveRecord::Base
  actable
  
  belongs_to :user
  has_one :raw_extraction, as: :contributable, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true
end
