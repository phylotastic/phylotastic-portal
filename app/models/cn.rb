class Cn < ApplicationRecord
  belongs_to :user
  
  has_one :list, as: :resource, dependent: :destroy
  
  has_attached_file :file, default_url: "/images/:style/missing.png"
  
  default_scope -> { order(created_at: :desc) }
  
  validates_attachment :file, 
    content_type: { content_type: [ "application/pdf", 
                                    "text/plain", 
                                    "application/vnd.ms-excel", 
                                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
                                    "application/msword",
                                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ] },
    size: { in: 0..2.megabytes, :message => "must be less than 2MB" }

  validates_attachment_presence :file
    
  def meta_origin
    file.original_filename
  end
end
