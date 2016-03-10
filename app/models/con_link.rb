class ConLink < ActiveRecord::Base
  belongs_to :user

  has_one :raw_extraction, as: :contributable, dependent: :destroy
  
  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true

  validates :uri, :presence => true, :url => true
end
