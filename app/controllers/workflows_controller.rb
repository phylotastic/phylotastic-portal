class WorkflowsController < ApplicationController
  before_action :get_tree
  
  include TreesHelper
  
  def update
    response = RestClient.post( APP_CONFIG["gf_server_with_traversing"],
      {
        :file => @tree.workflow        
      }.merge(params)
    )
    @explanation = JSON.parse(response)
    
    @image_res = RestClient.post(APP_CONFIG["sv_image"], 
      {
        tree_newick: JSON.parse( @tree.representation )["newick"], 
        format: "png", 
        tree_id: @tree.id
      }
    )
    
    link_to = JSON.parse(@image_res.body)["html_data"]
    match = /href\s*=\s*"([^"]*)"/.match(link_to)
    if match
      @href = match[1]
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def resolve
    resolved = JSON.parse(@tree.raw_extraction.species)

    chosen_species = JSON.parse(@tree.chosen_species).select {|k,v| v == "1"}.map {|k,v| k }
    
    resolved["resolvedNames"] = resolved["resolvedNames"].select do |r|
      if r.key?("matched_results")
        v = r["matched_results"][0]
      else
        v = r
      end
      chosen_species.include? v["matched_name"]
    end
    
    respond_to do |format|
      if chosen_species.length < 2
        format.js { render 'stop.js.erb' }
      else
        format.js
      end
    end
  end
  
  def alternative_extract_tree
    resolved = JSON.parse(@tree.raw_extraction.species)

    chosen_species = JSON.parse(@tree.chosen_species).select {|k,v| v == "1"}.map {|k,v| k }
    
    resolved["resolvedNames"] = resolved["resolvedNames"].select do |r|
      if r.key?("matched_results")
        v = r["matched_results"][0]
      else
        v = r
      end
      chosen_species.include? v["matched_name"]
    end
    
    extracted_response = Req.post( APP_CONFIG["sv_get_tree"]["url"],
                                     resolved.to_json,
                                     :content_type => :json,
                                     :accept => :json )

    if !extracted_response || extracted_response.empty?
      @tree.update_attributes( status: "unsuccessfully-extracted",
                              representation: nil )
      respond_to do |format|
        @e = "Timed out"
        format.js { render 'service_failed.js.erb' }
      end
    elsif JSON.parse(extracted_response)["message"] == "Success"
      extracted_response = extracted_response.to_s.gsub('\'', '')
      @tree.update_attributes( status: "unsuccessfully-scaled",
                              representation: extracted_response )
      respond_to do |format|
        format.js
      end
    else
      extracted_response = extracted_response.to_s.gsub('\'', '')
      @tree.update_attributes( status: "unsuccessfully-extracted",
                              representation: extracted_response )
      respond_to do |format|
        @e = extracted_response
        format.js { render 'service_failed.js.erb' }
      end
    end

  end
  
  def scale_tree
    @op = 3
    scaled_response = Req.post( APP_CONFIG["sv_datelife_tree"]["url"],
                                {"newick": sanitize_newick(@tree), method: "median"}.to_json,
                                :content_type => :json,
                                :accept => :json )

    if !scaled_response || scaled_response.empty?
      @tree.update_attributes( status: "unsuccessfully-scaled",
                              bg_job: "-1",
                              scaled_representation: nil )
      respond_to do |format|
        format.js { render 'service_failed.js.erb' }
      end
    elsif JSON.parse(scaled_response)["message"] == "Success"
      scaled_response = scaled_response.to_s.gsub('\'', '')
      @tree.update_attributes( status: "completed",
                              bg_job: "-1",
                              scaled_representation: scaled_response )
      respond_to do |format|
        format.js
      end
    else
      scaled_response = scaled_response.to_s.gsub('\'', '')
      @tree.update_attributes( status: "unsuccessfully-scaled",
                              bg_job: "-1",
                              scaled_representation: scaled_response )
      respond_to do |format|
        @e = scaled_response
        format.js { render 'service_failed.js.erb' }
      end

    end
  end
  
  
  def extract_tree
    @op = 2
    resolved = JSON.parse(@tree.raw_extraction.species)

    chosen_species = JSON.parse(@tree.chosen_species).select {|k,v| v == "1"}.map {|k,v| k }
    taxa = {}
    resolved["resolvedNames"] = resolved["resolvedNames"].select do |r|
      if r.key?("matched_results")
        v = r["matched_results"][0]
      else
        v = r
      end
      chosen_species.include? v["matched_name"]
    end
    
    taxa["taxa"] = resolved["resolvedNames"].map do |r|
      if r.key?("matched_results")
        v = r["matched_results"][0]
      else
        v = r
      end
      v["matched_name"]
    end 
    
    extracted_response = Req.post( "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/gt/pt/tree" + "aaa",
                                     taxa.to_json,
                                     :content_type => :json,
                                     :accept => :json )

    if !extracted_response || extracted_response.empty?
      @tree.update_attributes( status: "unsuccessfully-extracted",
                              representation: nil )
      respond_to do |format|
        format.js { render 'service_failed.js.erb' }
      end
    elsif JSON.parse(extracted_response)["message"] == "Success"
      extracted_response = extracted_response.to_s.gsub('\'', '')
      @tree.update_attributes( status: "unsuccessfully-scaled",
                              representation: extracted_response )
      respond_to do |format|
        format.js
      end
    else
      extracted_response = extracted_response.to_s.gsub('\'', '')
      @tree.update_attributes( status: "unsuccessfully-extracted",
                              representation: extracted_response )
      respond_to do |format|
        @e = extracted_response
        format.js { render 'service_failed.js.erb' }
      end
    end

  end
  
  private
  def get_tree
    @tree = Tree.find(params["tree"])
  end
end
