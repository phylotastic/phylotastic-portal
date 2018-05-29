class AddAttachmentImageToTrees < ActiveRecord::Migration[5.1]
  def self.up
    change_table :trees do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :trees, :image
  end
end
