class WorkflowController < ApplicationController
  def update
    @tree = Tree.find(params["tree"])
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
end
