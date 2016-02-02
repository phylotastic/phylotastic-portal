class ConFile < ActiveRecord::Base
  belongs_to :user
  
  has_many :raw_extraction, as: :contributable
  
  has_attached_file :document, default_url: "/images/:style/missing.png"
  validates_attachment :document, content_type: { content_type: [ "application/pdf", 
                                                                  "text/plain", 
                                                                  "application/vnd.ms-excel", 
                                                                  "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
                                                                  "application/msword",
                                                                  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ] }
  validates_attachment_presence :document
end
