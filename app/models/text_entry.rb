class TextEntry < ApplicationRecord
  has_one :list, as: :resource, dependent: :destroy
  belongs_to :user
  
  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  validates :corpus, presence: true
end
