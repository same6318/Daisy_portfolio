Rails.application.routes.draw do
  get 'static_pages/terms_of_service'
  get 'static_pages/privacy_policy'
  get 'oauth/index'
  root 'top#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: 'users/sessions'
  }

  resources :users, only: [:show, :edit, :update, :index] 
  resources :companies

  resources :users do
    resources :reviews, only: [:show] # 必要なアクションを追加
  end
  
  resources :topics
  resources :companies do #企業のidを選んだ上でレビューする。
    resources :reviews
  end


  devise_scope :user do
    get "admin/sign_in", to: "admin/sessions#new", as: :new_admin_session
    post "admin/sign_in", to: "admin/sessions#create", as: :admin_session
    delete "admin/sign_out", to: "admin/sessions#destroy", as: :destroy_admin_session
  end

  namespace :admin do
    #resources :sessions, only: [:new, :create, :destroy] admin/sign_inと同じことを書いているので要らない。
    resources :users, only: [:index, :show, :destroy]
    resources :topics , only: [:index, :show, :destroy]
    resources :reviews, only: [:index, :show, :destroy]
    resources :companies, only: [:index, :show, :destroy]
  end

  resources :topics
  resources :companies do #企業のidを選んだ上でレビューする。
    resources :reviews
  end
end
