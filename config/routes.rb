Rails.application.routes.draw do
  
  root to: 'visitors#index'
  devise_for :users
  resources :users
  

  resources :bets,     only: [ :show, :create ]
  resources :cashouts, only: [ :create ]
  resources :transactions, only: [ :index ]
  
  get 'configuration' => 'visitors#configure'
  
  get "/bet_table" => "visitors#bet_table"
end
