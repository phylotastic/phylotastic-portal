Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ActionCable.server => '/cable'
  
  resources :trees, only: [:show, :update, :destroy] do
    member do
      get 'download'
      get 'wf'
      post "wf_update"
      get 'metadata'
      get 'download_tree_info'
    end
  end
  
  resources :lists, only: [:show, :edit, :update, :index, :destroy] do
    resources :trees, only: [:index, :create]
    resources :taxon, only: [:show]
    member do
      post 'resolve_names'
      post 'download'
    end
  end

  resources :text_entries, only: [:new, :create]
  resources :links, only: [:new, :create]
  resources :documents, only: [:new, :create]
  resources :onpls, only: [:new, :create]
  resources :cns, only: [:new, :create]
  resources :dcas, only: [:new, :create] do
    member do
      get 'publish'
    end
  end
  
  resources :taxonomies, only: [:new, :create] do
    member do
      post 'choose'
    end
  end

  get 'static_pages/help'
  get 'static_pages/feedback'
  get 'static_pages/about'
  post 'trees/download_studies'
  
  devise_for :users, controllers: { sessions:      "users/sessions", 
                                    passwords:     "users/passwords",
                                    registrations: "users/registrations",
                                    confirmations: "users/confirmations", }
       
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: "lists#index"
end
