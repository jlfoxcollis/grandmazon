Rails.application.routes.draw do
    root to: "welcome#index"

    devise_for :users, controllers: {:registrations => "users/registrations", confirmations: 'confirmations' }
    resources :users, only: [:show], module: :users do
      resources :merchants, only: [:new, :create, :edit, :update, :destroy ]
      resources :orders, only: [:index, :create, :show]
      resources :invoices, only: [:index, :show]
    end

    resources :welcome, only: [:index]
    namespace :shopping do
      resources :cart, only: [:show, :update, :destroy]
      resources :checkout, only: [:index]
      resources :merchants, only: [:show] do
        resources :items, only: [:show]
      end
    end

    resources :admin, controller: 'admin/dashboard', only: [:index]
    namespace :admin do
      resources :merchants, except: [:destroy]
      resources :merchants_status, only: [:update]
      resources :invoices_status, only: [:update]
      resources :invoices, only: [:index, :show]
    end

    resources :merchants, only: [:show], module: :merchant do
      resources :discounts
      resources :items
      resources :items_status, controller: "merchant_items_status", only: [:update]
      resources :invoices do
        resources :applied_discounts, only: [:index]
      end
      resources :invoice_items, only: [:update]
      resources :dashboard, only: [:index]
    end


  end
