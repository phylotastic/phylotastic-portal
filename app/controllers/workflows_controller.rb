class WorkflowsController < ApplicationController
  include TreesHelper
  
  def scale_sdm
    @tree = Tree.find(params[:id])
    
    scaled_response = Req.post( Rails.configuration.x.sv_Datelife_scale_tree,
                                {"newick": sanitize_newick(@tree), method: "sdm"}.to_json,
                                :content_type => :json, 
                                :accept => :json )
    
    if scaled_response.empty?
      respond_to do |format|
        format.js { render 'scaling_failed.js.erb' }
      end
    else
      @tree.update_attributes(scaled_sdm: scaled_response)
      respond_to do |format|
        format.js
      end
    end
    
  end
end
