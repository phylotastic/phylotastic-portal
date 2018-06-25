require "Newick"

module TreesHelper
  def sanitize_newick(nw)
    nw.gsub(/_ott\d*/, '').gsub(/_/, ' ') 
  end
  
  def scaled_tree_state(tree, field_data, parsed, field_name, x)
    if parsed.empty?
      if field_data.nil?
        # processing
        html = "<span class='center loading'><i class=\"fa fa-spin fa-spinner\" aria-hidden=\"true\"></i></span>"
      else
        # error
        html = "<span class='center'>#{fa_icon "exclamation-triangle"}</span>"
      end
    else
      html = "<input type=\"radio\" name=\"tree-version\" id=\"#{field_name}\" value=\"#{field_name}\"><a href=\"/trees/#{tree.id}?method=#{field_name}" 
      html += "&x=1" if x.nil?
      html += "&x=2" if x == "1" || x == "2"
      html += "\"></a>"
    end
    return "<div class='scaled-tree-context-wrapper'>#{html}</div>".html_safe
  end
  
  def tips(nw)
    number = NewickTree.new(nw.to_s).root.leaves.count rescue '?'
    number.to_s + " tips"
  end
end
