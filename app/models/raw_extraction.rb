class RawExtraction < ActiveRecord::Base
  has_many :trees, dependent: :destroy
  belongs_to :contributable, polymorphic: true
  
  def user
    contributable.user
  end
  
end
