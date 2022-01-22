Rails.application.routes.draw do
  get "clients/:client_id/credit", to: "transactions#credit", as: 'credit_transaction'
  post "clients/:client_id/create_credit", to: "transactions#create_credit", as: 'create_credit_transaction'
  get "clients/:client_id/debit", to: "transactions#debit", as: 'debit_transaction'
  post "clients/:client_id/create_debit", to: "transactions#create_debit", as: 'create_debit_transaction'
  
  resources :clients do
    resources :transactions, only: [:index]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "clients#index"
end
