Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  root 'raw_extractions#index'

  resources :raw_extractions, only: [:index] do 
    member do
      post "download_selected_species"
    end
  end
  
  resources :user_list_relationships, only: [:destroy]
  
  resources :uploaded_lists, only: [:create, :show, :destroy, :update, :new] do
    collection do
      post 'update_metadata' => "uploaded_lists#update_metadata"
      post 'update_species' => "uploaded_lists#update_species"
      post 'update_a_species' => "uploaded_lists#update_a_species"
      post 'clone' => "uploaded_lists#clone"
      get 'list_content' => 'uploaded_lists#list_content'
      get 'trees' => 'uploaded_lists#trees'
      get 'publish' => 'uploaded_lists#publish'
      get 'failed' => 'uploaded_lists#failed'
      get 'show_public' => 'uploaded_lists#show_public'
    end
  end

  get 'matched_names/show'

  get '/track' => 'trackers#track'
  
  require 'sidekiq/web'
  # ...
  mount Sidekiq::Web, at: '/sidekiq'
  
  resources :con_taxons
  resources :con_files  
  resources :con_links
  resources :onpl_files do
    collection do
      post 'update_a_species' => "onpl_files#update_a_species"
    end
  end
 
  resources :trees do
    collection do
      patch ':id/public' => 'trees#public', as: :public
      get 'public_gallery' => 'trees#public_gallery', as: :public_gallery
      get 'image_getter' => 'trees#image_getter'
      post 'generate_image' => 'trees#generate_image', format: :svg 
      get 'taxon_matching_report' => 'trees#taxon_matching_report'
      get 'newick' => 'trees#newick'
      post 'update_description' => 'trees#update_description'
      get 'download_image' => 'trees#download_image'
      get 'status' => 'trees#status', as: :status
      get 'checking_status' => 'trees#checking_status'
    end
  end
    
  get 'user/:id/gallery', to: "watch_relationships#gallery", as: :gallery
  
  resources :watch_relationships, only: [:create, :destroy]
  get '/add_public_gallery' => 'watch_relationships#add_public_gallery', as: :pub_gal
  
  get 'static_pages/about'
  get 'static_pages/help'
  get 'static_pages/feedback'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
