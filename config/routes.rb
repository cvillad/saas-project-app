Rails.application.routes.draw do
  resources :artifacts
  resources :tenants do
    resources :projects
  end
  resources :members
  get 'home/index'
  root to: "home#index"
    
  as :user do   
    put '/user/confirmation', to: 'confirmations#update', as: :update_user_confirmation
  end

  devise_for :users, controllers: { 
    registrations: "registrations",
    confirmations: "confirmations",
    sessions: "milia/sessions", 
    passwords: "milia/passwords", 
  }
  
  get "/plan/edit", to: "tenants#edit", as: :edit_plan
  match '/plan/update' => 'tenants#update', via: [:put, :patch], as: :update_plan

end
