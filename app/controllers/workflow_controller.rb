class WorkflowController < ApplicationController
  def update
    @tree = Tree.find(params["tree"])
    response = RestClient.post( APP_CONFIG["gf_server_with_traversing"],
      {
        :file => @tree.workflow        
      }.merge(params)
    )
    @explanation = JSON.parse(response)
    respond_to do |format|
      format.js
    end
  end
end
