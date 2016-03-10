class SelectionTaxon < ActiveRecord::Base  
  belongs_to :user
  has_one :raw_extraction, as: :contributable, dependent: :destroy
  acts_as :con_taxon, validates_actable: false
    
  validates :criterion, inclusion: { in: %w(Populatity Random),
      message: "%{value} is not a valid criterion" }
end
