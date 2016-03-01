class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def convert_to_resolved_format(response_species)
    faker = {resolvedNames: []}
    JSON.parse(response_species)["species"].each do |n| 
      faker[:resolvedNames] << { match_type: "Exact", 
                                 resolver_name: "OT", 
                                 matched_name: n, 
                                 search_string: n, 
                                 synonyms: [] }
    end
    return faker.to_json
  end

  def convert_to_chosen_species_format(response_species, nb_species, criterion)
    faker = {}
    species = JSON.parse(response_species)["species"]
    case criterion
    when "Populatity"
      if nb_species < species.count
        # TODO: call services to determine which species will be included in tree
        # for now, take all
        species.each {|n| faker[n] = "1"}
      else
        species.each {|n| faker[n] = "1"}
      end
    when "Random"
      if nb_species < species.count
        species.sample(nb_species).each {|n| faker[n] = "1"}
      else
        species.each {|n| faker[n] = "1"}
      end
    when "All"
      species.each {|n| faker[n] = "1"}
    end
    return faker.to_json
  end
  
  def convert_to_extracted_response(response_species)
    species = JSON.parse(response_species)["species"]
    faker = {scientificNames: []}
    faker[:scientificNames].concat species
    return faker.to_json
  end

end
