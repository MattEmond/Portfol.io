Rails.application.routes.draw do
  resources :stocks
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  #get 'home/index'
  root 'home#index'
  get 'home/about'

  get 'stocks/historical_chart/:stock', :to => 'stocks#historical_chart'
  get 'stocks/stock_news/:stock', :to => 'stocks#stock_news'

  get '/search', :to => 'stocks#search', as: :stock_search

  post "/" => 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
