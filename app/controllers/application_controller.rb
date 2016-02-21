class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def convert_to_resolved_format(response_species)
    faker = {"resolvedNames": []}
    JSON.parse(response_species)["species"].each do |n| 
      faker[:resolvedNames] << { "match_type": "Exact", 
                                  "resolver_name": "OT", 
                                  "matched_name": n, 
                                  "search_string": n, 
                                  "synonyms": [] }
    end
    return faker.to_json
  end

  def convert_to_chosen_species_format(response_species)
    faker = {}
    JSON.parse(response_species)["species"].each {|n| faker[n] = "1"}
    return faker.to_json
  end
  
end
