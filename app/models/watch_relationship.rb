class WatchRelationship < ActiveRecord::Base
  belongs_to :tree
  belongs_to :user

  validates :tree_id, presence: true
  validates :user_id, presence: true  
end
