class ConTaxon < ActiveRecord::Base
  actable
  
  belongs_to :user
  has_one :raw_extraction, as: :contributable, dependent: :destroy
end
