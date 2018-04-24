Rails.application.routes.draw do

  resources :lists, only: [:edit, :update, :index, :destroy]

  resources :links, only: [:new, :create, :destroy]

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
