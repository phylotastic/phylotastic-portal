class AddAttachmentDocumentToConFiles < ActiveRecord::Migration
  def self.up
    change_table :con_files do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :con_files, :document
  end
end
