class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :rememberable, :recoverable
         # , :confirmable
   # :trackable, :validatable
         
  validates :email, presence: true
  has_many  :links, dependent: :destroy
  has_many  :documents, dependent: :destroy
  has_many  :onpls, dependent: :destroy
    
  def lists
    lists = []
    online_resource_lists = self.links.map {|l| l.list}
    lists.concat online_resource_lists

    document_resource_lists = self.documents.map {|l| l.list}
    lists.concat document_resource_lists
    
    onpl_resource_lists = self.onpls.map {|l| l.list}
    lists.concat onpl_resource_lists
  end
end
