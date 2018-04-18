class AddReasonToConTaxons < ActiveRecord::Migration
  def change
    add_column :con_taxons, :reason, :string
  end
end
