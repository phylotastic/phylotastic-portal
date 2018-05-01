class AddAttachmentFileToDcas < ActiveRecord::Migration[5.1]
  def self.up
    change_table :dcas do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :dcas, :file
  end
end
