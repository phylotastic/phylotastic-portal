class OnplsController < ApplicationController
  def new
    @onpl = Onpl.new
  end

  def create
    @onpl = current_or_guest_user.onpls.build(onpl_params)
    if @onpl.save
      name = params[:name].empty? ? @onpl.file.original_filename : params[:name]
      @list = @onpl.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"
      # job_id = ExtractionsWorker.perform_async(@con_link.id, "ConLink", @user.id)
      redirect_to root_path
    else
      render action: "new"
    end
  end
  
  private
  
    def onpl_params
      params.require(:onpl).permit(:file)
    end
end
