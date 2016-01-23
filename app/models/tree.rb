class Tree < ActiveRecord::Base
  belongs_to :user
  belongs_to :phylo_source
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
end
