Rails.application.routes.draw do
  
  root 'raw_extractions#index'

  get 'user_list_relationships/destroy'

  resources :user_list_relationships, only: [:destroy]
  
  resources :uploaded_lists, only: [:create, :show, :destroy, :update, :new] do
    collection do
      post 'update_species' => "uploaded_lists#update_species"
      post 'update_a_species' => "uploaded_lists#update_a_species"
      post 'clone' => "uploaded_lists#clone"
      get 'list_content' => 'uploaded_lists#list_content'
      get 'trees' => 'uploaded_lists#trees'
      get 'publish' => 'uploaded_lists#publish'
      get 'failed' => 'uploaded_lists#failed'
    end
  end

  get 'matched_names/show'

  get '/track' => 'trackers#track'
  
  require 'sidekiq/web'
  # ...
  mount Sidekiq::Web, at: '/sidekiq'
  
  resources :con_taxons
  
  resources :con_files do
    collection do
      get 'onpl' => 'con_files#onpl'
    end
  end
  
  resources :con_links
  resources :subset_taxon
  resources :selection_taxon
 
  resources :trees do
    collection do
      patch ':id/update_image' => 'trees#update_image', as: :update_image
      patch ':id/public' => 'trees#public', as: :public
      get 'search' => 'trees#search'
      get 'image_getter' => 'trees#image_getter'
      post 'generate_image' => 'trees#generate_image', format: :svg 
      get 'taxon_matching_report' => 'trees#taxon_matching_report'
      post 'update_description' => 'trees#update_description'
      get 'download_image' => 'trees#download_image'  
    end
  end
  
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  
  get 'user/:id/gallery', to: "watch_relationships#gallery", as: :gallery
  
  resources :watch_relationships, only: [:create, :destroy]
  
  get 'static_pages/about'
  get 'static_pages/faq'
  get 'static_pages/videos'
  
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
