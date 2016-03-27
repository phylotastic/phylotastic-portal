Rails.application.routes.draw do
  
  resources :uploaded_lists, only: [:create, :show, :destroy, :update]

  get 'matched_names/show'

  get '/track' => 'trackers#track'
  
  require 'sidekiq/web'
  # ...
  mount Sidekiq::Web, at: '/sidekiq'
  
  resources :con_taxons
  resources :selection_taxons
  resources :subset_taxons
  resources :con_files
  resources :con_links
  
  get 'raw_extractions/new_from_file_and_web'
  get 'raw_extractions/new_from_pre_built_examples'
  get 'raw_extractions/new_from_taxon'

  resources :trees do
    collection do
      patch ':id/update_image' => 'trees#update_image', as: :update_image
      patch ':id/public' => 'trees#public', as: :public
      get 'explore'
      get 'search' => 'trees#search'
    end
  end
  
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  
  get 'user/:id/gallery', to: "watch_relationships#gallery", as: :gallery
  
  resources :watch_relationships, only: [:create, :destroy]
  
  root 'static_pages#home'
  get 'static_pages/about'
  get 'static_pages/faq'
  
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
