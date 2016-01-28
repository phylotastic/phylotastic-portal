class ConFile < ActiveRecord::Base
  belongs_to :user
  
  has_many :raw_extraction, as: :contributable
end
