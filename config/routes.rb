DostorStatus::Application.routes.draw do
  devise_for :users
  resources :articles

  get "/contact", to: "pages#contact"
  get "/privacy", to: "pages#privacy"
  get "/tos", to: "pages#tos"

  root :to => 'articles#index'
end
