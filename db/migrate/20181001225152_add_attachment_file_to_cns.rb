class AddAttachmentFileToCns < ActiveRecord::Migration[5.1]
  def self.up
    change_table :cns do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :cns, :file
  end
end
