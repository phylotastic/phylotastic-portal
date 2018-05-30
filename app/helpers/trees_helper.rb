module TreesHelper
  def sanitize_newick(tree)
    tree.unscaled.gsub(/_ott\d*/, '').gsub(/_/, ' ') 
  end
end
