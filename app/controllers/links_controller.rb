class LinksController < ApplicationController
  def new
    @link = Link.new
  end

  def create
    @link = current_or_guest_user.links.build(link_params)
    if @link.save
      name = params[:name].empty? ? link_params[:url] : params[:name]
      # binding.pry
      @list = @link.create_list(name: name, description: params[:description])
      flash[:success] = "ABC"
      # job_id = ExtractionsWorker.perform_async(@con_link.id, "ConLink", @user.id)
      redirect_to root_path
    else
      render action: "new"
    end
  end

  def destroy
  end
  
  private
  
    def link_params
      params.require(:link).permit(:url)
    end
    
end
