Rails.application.routes.draw do

  resources :trees, only: [:show, :edit, :update, :destroy]
  resources :lists, only: [:show, :edit, :update, :index, :destroy] do
    resources :trees, only: [:index, :create]
  end

  resources :links, only: [:new, :create]
  resources :documents, only: [:new, :create]
  resources :onpls, only: [:new, :create]
  resources :dcas, only: [:new, :create]
  resources :taxonomies, only: [:new, :create]

  get 'static_pages/help'
  get 'static_pages/feedback'
  get 'static_pages/about'

  devise_for :users, controllers: { sessions:      "users/sessions", 
                                    passwords:     "users/passwords",
                                    registrations: "users/registrations",
                                    confirmations: "users/confirmations", }
       
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: "lists#index"
end
