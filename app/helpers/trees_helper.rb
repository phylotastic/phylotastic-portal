module TreesHelper
  def sanitize_newick(tree)
    tree.unscaled.gsub(/_ott\d*/, '').gsub(/_/, ' ') 
  end
  
  def scaled_tree_state(field_data, parsed, field_name)
    if parsed.empty?
      if field_data.nil?
        # processing
        html = "<span class='center loading'><i class=\"fa fa-spin fa-spinner\" aria-hidden=\"true\"></i></span>"
      else
        # error
        html = "<span class='center'>#{fa_icon "exclamation-triangle"}</span>"
      end
    else      
      html = "<input type=\"radio\" name=\"tree-version\" id=\"#{field_name}\" value=\"#{field_name}\">"
    end
    return "<div class='scaled-tree-context-wrapper'>#{html}</div>".html_safe
  end
end
