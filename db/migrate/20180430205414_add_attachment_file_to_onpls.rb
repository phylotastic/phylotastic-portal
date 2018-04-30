class AddAttachmentFileToOnpls < ActiveRecord::Migration[5.1]
  def self.up
    change_table :onpls do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :onpls, :file
  end
end
