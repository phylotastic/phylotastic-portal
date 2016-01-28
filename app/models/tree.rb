class Tree < ActiveRecord::Base
  belongs_to :user
  belongs_to :phylo_source
  belongs_to :raw_extraction
  
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
end
