class Link < ApplicationRecord
  has_one :list, as: :resource, dependent: :destroy
  belongs_to :user
  
  validates :user_id, presence: true
  validates :url, presence: true, uri: true  
end
