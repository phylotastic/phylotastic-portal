class RawExtraction < ActiveRecord::Base
  has_many :trees, dependent: :destroy
  belongs_to :contributable, polymorphic: true
  belongs_to :users
  
  def name
    contributable.name
  end
  
  def user
    contributable.user
  end
  
  def build_tree?
    return false if self.species.nil?
    begin
      extracted_names = JSON.parse(self.species)["resolvedNames"]
    rescue Exception => e
      extracted_names = []
    end
    return false if extracted_names.nil?
    return false if extracted_names.count < 2
    return true
  end
  
end
