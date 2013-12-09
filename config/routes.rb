DostorStatus::Application.routes.draw do
  get "welcome/index"

  devise_for :admins
  devise_for :users

  scope 'admin' do
    resources :articles
    resources :users, only: [:index, :destroy]
  end

  get "/dostor-test", to: "welcome#naqeshny"

  get "/fb_callback", to: "welcome#fb_callback", as: :oauth_redirect
  get "/fb_login", to: "welcome#fb_login", as: :fb_login
  get "/fb_logout", to: "welcome#fb_logout", as: :fb_logout

  get "/about", to: "pages#about"
  get "/privacy", to: "pages#privacy"
  get "/tos", to: "pages#tos"

  get "/:number", to: "welcome#index", as: :article_page
  get "articles/:number", to: "Naqeshny::Naqeshny#index", as: :article_naqeshny_page

  match "/naqesh/:article_number", to: redirect("http://beta.naqeshny.com/statuses/http-slash-slash-dostor-dot-mashsolvents-dot-com-slash-%{article_number}-number-nqsh-dstwrk"), as: :naqeshny

  root :to => 'welcome#index'
end
