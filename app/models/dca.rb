require 'csv'
# require 'roo'

class Dca < ApplicationRecord
  belongs_to :user
  
  has_one :list, as: :resource, dependent: :destroy
  
  has_attached_file :file, default_url: "/images/:style/missing.png"
  
  default_scope -> { order(created_at: :desc) }
  
  validates_attachment :file, 
    content_type: { content_type: "application/zip", :message => ": Make sure to zip your files" },
    size: { in: 0..500.kilobytes, :message => "must be less than 500kB" }

  validates_attachment_presence :file
    
  def meta_origin
    file.original_filename
  end
end
