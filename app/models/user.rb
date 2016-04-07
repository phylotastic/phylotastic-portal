class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  
  has_many :trees, dependent: :destroy
  has_many :con_files, dependent: :destroy
  has_many :con_links, dependent: :destroy
  has_many :con_taxons, dependent: :destroy
  has_many :selection_taxons, dependent: :destroy
  has_many :subset_taxons, dependent: :destroy
  has_many :watch_relationships, dependent: :destroy
  has_many :watched_trees, through: :watch_relationships, source: :tree
  has_many :uploaded_lists, dependent: :destroy
  has_many :user_list_relationships, dependent: :destroy
  has_many :prebuilt_lists, through: :user_list_relationships, source: :uploaded_list
  
  validates_format_of :email, :with => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  
  def self.from_omniauth(auth)
    u = where(email: auth.info.email)
    if u.empty?
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
      end
    else
      # update information for existed user
      u.first.provider = auth.provider
      u.first.uid = auth.uid
      u.first.save
    end
  end
  
  def name
    self.email.partition('@').first
  end
  
  # Watchs a tree.
  def watch(tree)
    watch_relationships.create(tree_id: tree.id)
  end

  # Unwatchs a tree.
  def unwatch(tree)
    watch_relationships.find_by(tree_id: tree.id).destroy
  end

  # Returns true if the current user is following the other user.
  def watching?(tree)
    watched_trees.include?(tree)
  end
  
  # Create user_list_relationships
  def subcribe(list)
    user_list_relationships.first_or_create(uploaded_list_id: list.id) 
  end
  
  # Destroy user_list_relationships
  def unsubcribe(list)
    user_list_relationships.find_by(uploaded_list_id: list.id).destroy
  end
  
  # Select all trees a user created from a public list.
  def trees_from_public_list(list)
    list.raw_extraction.trees.where(user_id: self.id)
  end
end
