Rails.application.routes.draw do
  get 'static_pages/help'
  get 'static_pages/feedback'
  get 'static_pages/about'

  devise_for :users, controllers: { sessions: 'users/sessions' }
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: "static_pages#help"
end
