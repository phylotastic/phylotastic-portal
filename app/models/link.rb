class Link < ApplicationRecord
  has_one :list, as: :resource, dependent: :destroy
  belongs_to :user
  
  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  validates :url, presence: true, uri: true  
end
