class List < ApplicationRecord
  belongs_to :resource, polymorphic: true
  
  def dca_source?
    self.resource_type == "Dca"
  end
  
  def extracted_names
    begin
      n = JSON.parse(self.extracted)["scientificNames"]
      return n.nil? ? [] : n
    rescue
      []
    end
  end

  def species_names
    begin
      n = JSON.parse(self.resolved)["resolvedNames"]
      return n.nil? ? [] : n
    rescue
      []
    end
  end
  
  def unmatched_names
    begin
      species = self.species_names.map {|data| data["matched_results"][0]["matched_name"]}
    rescue
      species = []
    end
    
    extracted = self.extracted_names    
    extracted.select {|e| !species.include?(e) }
  end
  
  def trees
    Tree.where(list_id: self.id, list_from_service: false)
  end
  
  def destroy_trees
    self.trees.each do |t|
      t.destroy
    end
  end
end
