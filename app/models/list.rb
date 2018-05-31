class List < ApplicationRecord
  belongs_to :resource, polymorphic: true
  
  def extracted_names
    begin
      JSON.parse(self.extracted)["scientificNames"]
    rescue
      []
    end
  end

  def species_names
    begin
      JSON.parse(self.resolved)["resolvedNames"]
    rescue
      nil
    end
  end
  
  def unmatched_names
    species = self.species_names.map {|data| data["matched_results"][0]["matched_name"]}
    extracted = self.extracted_names
    extracted.select {|e| !species.include?(e) }
  end
  
  def trees
    Tree.where(list_id: self.id, list_from_service: false)
  end
end
