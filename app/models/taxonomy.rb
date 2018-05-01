class Taxonomy < ApplicationRecord
  belongs_to :user
  belongs_to :country, optional: true
  has_one :list, as: :resource, dependent: :destroy
  
  validates :taxon, presence: true  
end
