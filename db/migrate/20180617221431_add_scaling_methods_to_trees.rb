class AddScalingMethodsToTrees < ActiveRecord::Migration[5.1]
  def change
    add_column :trees, :scaled_median, :text
    add_column :trees, :scaled_ot, :text
    add_column :trees, :scaled_median_job_id, :string
    add_column :trees, :scaled_ot_job_id    , :string
    add_column :trees, :scaled_sdm_job_id   , :string
  end
end
