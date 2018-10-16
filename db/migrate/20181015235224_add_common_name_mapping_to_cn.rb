class AddCommonNameMappingToCn < ActiveRecord::Migration[5.1]
  def change
    add_column :cns, :common_name_mapping, :text
  end
end
