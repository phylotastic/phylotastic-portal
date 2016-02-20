class Country < ActiveRecord::Base
  has_many :subset_taxons, dependent: :destroy
end
