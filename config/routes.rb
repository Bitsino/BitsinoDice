Primedice::Application.routes.draw do
  
  devise_for :users, controllers: { sessions: 'sessions' }, skip: [ :registrations ]

  resources :users,    only: [ :create, :update ]
  resources :bets,     only: [ :show, :create ]
  resources :cashouts, only: [ :create ]
  resources :transactions, only: [ :index ]

  root :to => "home#index"
  
  get 'configuration' => 'home#configure'
  post 'cold_storages' => 'home#configure_create'
  
end
