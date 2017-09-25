class WorkflowController < ApplicationController
  def update
    response = RestClient.post( APP_CONFIG["gf_server_with_traversing"],
      {
        :file => Tree.find(params["tree"]).workflow        
      }.merge(params)
    )
    @explanation = JSON.parse(response)
    respond_to do |format|
      format.js
    end
  end
end
