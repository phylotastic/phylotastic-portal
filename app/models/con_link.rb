class ConLink < ActiveRecord::Base
  belongs_to :user

  has_many :raw_extraction, as: :contributable  
  
  validates :user_id, presence: true
  # TODO: format url
  validates :uri, presence: true
end
