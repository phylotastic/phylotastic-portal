module RawExtractionsHelper
  
  def unresolved_filter(names, resolved_names)
    unresolved = []
    names.each do |n| 
     flag = false 
     resolved_names.each do |r| 
       if r.key?("matched_results") 
         if r["matched_results"][0]["matched_name"] == n 
           flag = true 
         end 
       else 
         if r["matched_name"] == n 
           flag = true 
           break       
         end 
       end 
     end 
     unresolved << n if !flag 
    end
    return unresolved 
  end
  
end
