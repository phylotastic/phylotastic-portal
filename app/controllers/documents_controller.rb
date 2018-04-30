class DocumentsController < ApplicationController
  def new
    @document = Document.new
  end

  def create
    @document = current_or_guest_user.documents.build(document_params)
    if @document.save
      name = params[:name].empty? ? link_params[:url] : params[:name]
      @list = @document.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"
      # job_id = ExtractionsWorker.perform_async(@con_link.id, "ConLink", @user.id)
      redirect_to root_path
    else
      render action: "new"
    end
  end
  
  private
  
    def document_params
      params.require(:document).permit(:file, :method)
    end
end
