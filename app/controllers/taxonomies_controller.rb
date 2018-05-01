class TaxonomiesController < ApplicationController
  def new
    @taxonomy = Taxonomy.new
  end

  def create
    @taxonomy = current_or_guest_user.taxonomies.build(taxonomy_params)
    if @taxonomy.save
      name = params[:name].empty? ? @taxonomy.taxon : params[:name]
      @list = @taxonomy.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"
      # job_id = ExtractionsWorker.perform_async(@con_link.id, "ConLink", @user.id)
      redirect_to root_path
    else
      render action: "new"
    end
  end
  
  private
  
    def taxonomy_params
      params.require(:taxonomy).permit(
        :taxon, :location, :country_id, :has_genome_in_ncbi, :quantity, :number_species)
    end
end
