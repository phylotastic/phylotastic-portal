class AddBgJobToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :bg_job, :string
  
    add_index :trees, [:bg_job]  
  end
end
