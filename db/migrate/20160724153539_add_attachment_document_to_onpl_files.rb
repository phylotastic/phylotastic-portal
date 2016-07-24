class AddAttachmentDocumentToOnplFiles < ActiveRecord::Migration
  def self.up
    change_table :onpl_files do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :onpl_files, :document
  end
end
