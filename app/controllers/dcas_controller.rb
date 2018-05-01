class DcasController < ApplicationController
  def new
    @dca = Dca.new
  end

  def create
    @dca = current_or_guest_user.dcas.build(dca_params)
    if @dca.save
      name = @dca.file.original_filename
      @list = @dca.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"
      # job_id = ExtractionsWorker.perform_async(@con_link.id, "ConLink", @user.id)
      redirect_to root_path
    else
      render action: "new"
    end
  end
  
  private
  
    def dca_params
      params.require(:dca).permit(:file)
    end
end
