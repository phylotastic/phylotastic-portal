class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
  :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
           # , :facebook]
  
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
  has_many :subcribing_lists, through: :user_list_relationships, source: :uploaded_list
  
  validates_format_of :email, :with => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  
  def self.from_omniauth(auth)
    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    u = where(email: auth.info.email).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
    u.update_attributes( access_token: auth.credentials.token,
                         expires_at: auth.credentials.expires_at,
                         refresh_token: auth.credentials.refresh_token )
    u
  end
  
  def refresh_token_if_expired
    if token_expired?
      response    = RestClient.post "https://accounts.google.com/o/oauth2/token", :grant_type => 'refresh_token', :refresh_token => self.refresh_token, :client_id => APP_CONFIG['google']["id"], :client_secret => APP_CONFIG['google']["secret"] 
      refreshhash = JSON.parse(response.body)

      # token_will_change!
      # expiresat_will_change!
      self.access_token = refreshhash['access_token']
      self.expires_at   = DateTime.now + refreshhash["expires_in"].to_i.seconds

      self.save
      puts 'Saved'
    end
  end

  def token_expired?
    expiry = Time.at(self.expires_at) 
    return true if expiry < Time.now # expired token, so we should quickly return
    token_expires_at = expiry
    save if changed?
    false # token not expired. :D
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
    if user_list_relationships.where(uploaded_list_id: list.id).empty?
      user_list_relationships.create(uploaded_list_id: list.id)
    end
  end
  
  # Destroy user_list_relationships
  def unsubcribe(list)
    user_list_relationships.find_by(uploaded_list_id: list.id).destroy
  end
  
  # Select all trees a user created from a public list.
  def trees_from_public_list(list)
    list.raw_extraction.trees.where(user_id: self.id)
  end
  
  def owned? list_json
    !list_json["user_id"].nil?
  end
  
  def failed_lists
    uploaded_lists.select {|u| u.status == false || u.status.nil? }
  end
  
  def processing_trees
    trees.select { |t| t.notifiable }.map { |t| t.id }
  end

end
