DostorStatus::Application.routes.draw do
  get "welcome/index"

  devise_for :admins

  devise_for :users
  resources :articles

  get "/fb_login", to: "welcome#fb_login", as: :fb_login
  get "/fb_logout", to: "welcome#fb_logout", as: :fb_logout

  get "/contact", to: "pages#contact"
  get "/privacy", to: "pages#privacy"
  get "/tos", to: "pages#tos"

  root :to => 'welcome#index'
end
