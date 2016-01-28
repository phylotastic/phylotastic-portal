class RawExtraction < ActiveRecord::Base
  has_many :trees
  belongs_to :contributable, polymorphic: true
end
