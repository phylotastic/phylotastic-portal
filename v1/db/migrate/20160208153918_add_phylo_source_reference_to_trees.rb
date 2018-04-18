class AddPhyloSourceReferenceToTrees < ActiveRecord::Migration
  def change
    add_reference :trees, :phylo_source, index: true, foreign_key: true
  end
end
