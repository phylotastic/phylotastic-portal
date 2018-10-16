class AddCommonNameMappingToTree < ActiveRecord::Migration[5.1]
  def change
    add_column :trees, :common_name_mapping, :text
    add_column :trees, :common_name_mapping_job_id, :string    
  end
end
