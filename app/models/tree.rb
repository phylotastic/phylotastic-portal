class Tree < ActiveRecord::Base
  belongs_to :user
  belongs_to :phylo_source
  belongs_to :raw_extraction 
  
  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  has_attached_file :image, styles: { large: "800x600>", medium: "400x300>", thumb: "120x90>" }, default_url: "/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  self.per_page = 9
  
  # searchable do
#     text :chosen_species, :description
#     boolean :public
#   end
  
  def semantic_status
    case self.status
    when "resolved"
      return "Names acquired: click \"Check name list\" to approve list and get a tree"
    when "unsucessfully-resolved"
      return "Sorry! We could not acquire a list of names!"
    when "unsuccessfully-constructed"
      if self.representation.nil?
        return "Sorry! We could not acquire a tree"
      else
        return "Sorry! We could not acquire a tree. Reason: #{JSON.parse(self.representation)['message']}"
      end
    when "completed"
      return "Tree acquired: click \"View tree\" to see it"
    when "no-names"
      return "There is no species names in your provided resource"
    end
  end

end