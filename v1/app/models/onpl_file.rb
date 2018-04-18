class OnplFile < ActiveRecord::Base
  belongs_to :user
  
  has_one :raw_extraction, as: :contributable, dependent: :destroy
  
  has_attached_file :document, default_url: "/images/:style/missing.png"
  
  default_scope -> { order(created_at: :desc) }
  
  validates :name, presence: true
  validates_attachment :document, content_type: { content_type: [ "application/pdf", 
                                                                  "text/plain", 
                                                                  "application/vnd.ms-excel", 
                                                                  "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
                                                                  "application/msword",
                                                                  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ] }
  validates_attachment_presence :document
  
  def meta_origin
    document.original_filename
  end
end
