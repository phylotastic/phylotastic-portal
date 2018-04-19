class List < ApplicationRecord
  belongs_to :resource, polymorphic: true
end
