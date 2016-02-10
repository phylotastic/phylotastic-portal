class TreesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @tree = current_user.trees.build
    @species = ["Admiral", "Ackbar", "Padm", "Amidala", "Wedge", "Antilles", "Cad", "Bane", "BB-8", "Darth", "Bane", "Jar", "Jar", "Binks", "C-3PO", "Lando", "Calrissian", "Chewbacca", "Poe", "Dameron", "Count", "Dooku", "(Darth", "Tyranus)", "Boba", "Fett", "Jango", "Fett", "Finn", "Greedo", "General", "Grievous", "Jabba", "the", "Hutt", "Qui-Gon", "Jinn", "Maz", "Kanata", "Obi-Wan", "Kenobi", "Princess", "Leia", "Darth", "Maul", "Palpatine", "(Darth", "Sidious)", "Captain", "Phasma", "R2-D2", "Rey", "Anakin", "Skywalker", "(Darth", "Vader)", "Luke", "Skywalker", "Kylo", "Ren", "Han", "Solo", "Ahsoka", "Tano", "Grand", "Moff", "Wilhuff", "Tarkin", "Asajj", "Ventress", "Watto", "Mace", "Windu", "Yoda"]
  end
  
  def create
    @tree = current_user.trees.build(tree_params)
    if @tree.save
      flash[:success] = "Tree created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end
  
  def show
    @tree = Tree.find_by(id: params[:id])
    if @tree.nil? 
      redirect_to root_url
    else
      if !@tree.public
        if @tree.user != current_user
          redirect_to root_url
        end
      end
    end
  end
  
  def index
    @trees = current_user.trees
    @processing = @trees.select { |t| t.status != "completed" }.map { |t| t.id }
  end
  
  def edit
    @tree = current_user.trees.find_by_id(params[:id])
    @species = ["Admiral", "Ackbar", "Padm", "Amidala", "Wedge", "Antilles", "Cad", "Bane", "BB-8", "Darth", "Bane", "Jar", "Jar", "Binks", "C-3PO", "Lando", "Calrissian", "Chewbacca", "Poe", "Dameron", "Count", "Dooku", "(Darth", "Tyranus)", "Boba", "Fett", "Jango", "Fett", "Finn", "Greedo", "General", "Grievous", "Jabba", "the", "Hutt", "Qui-Gon", "Jinn", "Maz", "Kanata", "Obi-Wan", "Kenobi", "Princess", "Leia", "Darth", "Maul", "Palpatine", "(Darth", "Sidious)", "Captain", "Phasma", "R2-D2", "Rey", "Anakin", "Skywalker", "(Darth", "Vader)", "Luke", "Skywalker", "Kylo", "Ren", "Han", "Solo", "Ahsoka", "Tano", "Grand", "Moff", "Wilhuff", "Tarkin", "Asajj", "Ventress", "Watto", "Mace", "Windu", "Yoda"]
  end
  
  def update
    @tree = current_user.trees.find_by_id(params[:id])
    if @tree.update_attributes(tree_params)
      flash[:success] = "Tree ##{params[:id]} is under constructed. We will notify you when it is ready"
      job_id = TreesWorker.perform_async(@tree.id)
      @tree.update_attributes(bg_job: job_id)  
      redirect_to trees_path
    else
      render 'edit'
    end
  end
  
  private
    def tree_params
      params.require(:tree).permit(:phylo_source_id, :branch_length, :images_from_EOL, :chosen_species)
    end
end
