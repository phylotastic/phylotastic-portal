class List < ApplicationRecord
  belongs_to :resource, polymorphic: true
  
  def species_names
    JSON.parse(self.resolved)["resolvedNames"]
  end
  
  def unmatched_names
  end
  
end
