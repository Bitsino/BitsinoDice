Rails.application.routes.draw do
  
  root to: 'visitors#index'
  devise_for :users
  resources :users
  
  scope defaults: (Rails.env.production? ? { protocol: 'https' } : {}) do
    devise_for :users
  end
  

  resources :bets,     only: [ :show, :create ]
  resources :cashouts, only: [ :create ]
  resources :transactions, only: [ :index ]
  
  get 'configuration' => 'visitors#configure'
  
  get "/bet_table" => "visitors#bet_table"
end
