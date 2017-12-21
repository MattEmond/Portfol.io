Rails.application.routes.draw do
  resources :stocks
  devise_for :users
  #get 'home/index'
  root 'home#index'
  get 'home/about'

  get 'stocks/one_day_chart/:stock', :to => 'stocks#one_day_chart'

  post "/" => 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
