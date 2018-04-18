class AddScaledSdmRepresentationToTree < ActiveRecord::Migration
  def change
    add_column :trees, :scaled_sdm_representation, :text
  end
end
