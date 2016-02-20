class SubsetTaxon < ActiveRecord::Base  
  belongs_to :user
  has_one :raw_extraction, as: :contributable, dependent: :destroy
  acts_as :con_taxon
  belongs_to :country
end
