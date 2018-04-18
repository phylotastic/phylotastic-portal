class ConLink < ActiveRecord::Base
  # before_validation :smart_add_url_protocol

  belongs_to :user

  has_one :raw_extraction, as: :contributable, dependent: :destroy
  
  default_scope -> { order(created_at: :desc) }
  
  validates :name, presence: true
  validates :user_id, presence: true
  validates :uri, :presence => true, :url => true  

  def meta_origin
    uri
  end

  # protected

  # def smart_add_url_protocol
  #   unless self.uri[/^https?:\/\//]
  #     self.uri = "http://#{self.uri}"
  #   end
  # end
    
end
