class UserListRelationship < ActiveRecord::Base
  belongs_to :uploaded_list
  belongs_to :user

  validates :uploaded_list_id, presence: true
  validates :user_id, presence: true  
end
