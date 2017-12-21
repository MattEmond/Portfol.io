Rails.application.routes.draw do
  resources :stocks
  devise_for :users
  #get 'home/index'
  root 'home#index'
  get 'home/about'
  get 'conversations/index'
  resources :users, only: [:index]
  resources :personal_messages, only: [:new, :create]

  post "/" => 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
