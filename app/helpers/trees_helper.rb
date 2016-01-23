module TreesHelper
  def phylo_sources_for_select
    PhyloSource.all.collect { |m| [m.name, m.id] }
  end
end
