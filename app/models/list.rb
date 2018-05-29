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
  end
  
end
