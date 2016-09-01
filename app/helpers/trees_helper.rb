module TreesHelper
  def phylo_sources_for_select
    PhyloSource.all.collect { |m| [m.name, m.id] }
  end
  
  def sanitize_newick(tree)
    JSON.parse(tree.representation)['newick'].gsub(/_ott\d*/, '').gsub(/_/, ' ') 
  end
end
