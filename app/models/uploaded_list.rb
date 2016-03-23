class UploadedList < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :file
  validates_attachment :file, presence: true,
    content_type: { content_type: "application/zip", :message => ": Make sure to zip your files" },
    size: { in: 0..500.kilobytes, :message => "must be less than 500kB" }
end
