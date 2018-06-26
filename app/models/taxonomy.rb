class Taxonomy < ApplicationRecord
  belongs_to :user
  belongs_to :country, optional: true
  has_one :list, as: :resource, dependent: :destroy
  
  validates :taxon, presence: true
  validates :number_population, numericality: { only_integer: true, less_than_or_equal_to: 100 }
end
