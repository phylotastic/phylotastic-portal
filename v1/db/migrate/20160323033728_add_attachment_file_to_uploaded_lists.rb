class AddAttachmentFileToUploadedLists < ActiveRecord::Migration
  def self.up
    change_table :uploaded_lists do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :uploaded_lists, :file
  end
end
