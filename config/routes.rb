CharitySystemManager::Application.routes.draw do
  root "site#index"

  #users
  get "/login"  => "users#login"
  post "/login" => "users#authenticate"
  get "/logout" => "users#logout"
  get "/signup" => "users#new"

  #charities
  get "/register_charity" => "charities#new"

  #pages
  get "/charities/:charity_id/" => "pages#show"

  resources :charities do
    resources :pages, :path => '' #removes the "pages" part of the url
  end

  resources :pages do
    resources :content
  end

  resources :users
end
