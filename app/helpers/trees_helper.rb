require "Newick"

module TreesHelper
  def sanitize_newick(nw)
    nw.gsub(/_ott\d*/, '').gsub(/_/, ' ').gsub(/\sott\d*/, '')
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
  
  def common_name_state(tree)
    common_name_tips = tree.common_name_tips
    if common_name_tips[:tip_list].empty?
      cn_id = CommonNameWorker.perform_async(tree.id)
      tree.update_attributes(common_name_mapping_job_id: cn_id)
      html = "<input type=\"checkbox\" id=\"common\" class=\"custom-tree-fields hide\"><span class='center loading'><i class=\"fa fa-spin fa-spinner\" aria-hidden=\"true\"></i></span>"
    else
      html = "<input type=\"checkbox\" id=\"common\" class=\"custom-tree-fields\"><span class='center loading hide'><i class=\"fa fa-spin fa-spinner\" aria-hidden=\"true\"></i></span>"
    end
    return "<span id='common_name_checkbox_holder'>#{html}</span>".html_safe
  end
  
  def tips(nw)
    number = NewickTree.new(nw.to_s).root.leaves.count rescue '?'
    number.to_s + " tips"
  end
end
