Rails.application.routes.draw do
  get 'oauth/index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: 'users/sessions'
  }

  resources :users, only: [:show, :edit, :update, :index] 
  resources :companies, only: [:show, :edit, :update, :index]
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html














































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
