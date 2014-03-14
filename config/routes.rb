CharitySystemManager::Application.routes.draw do
  root "welcome#index"

  #admin
  get "/admin/index"

  #admin charities
  get  "/admin/charities"                  => "admin#charities_index"
  get  "/admin/charities/:charity_id"      => "admin#charities_show"
  get  "/admin/charities/:charity_id/edit" => "charities#edit"
  post "/admin/charities/:charity_id/edit" => "charities#update"

  get  "charities/validate" => "admin#validate_charity", as: "charity_validate"
  post "charities/validate" => "admin#validate_charity"

  #requests
  get     "/admin/requests"                   => "requests#index"
  get     "/admin/requests/:request_id"       => "requests#show", as: "admin_request" 
  delete  "/admin/requests/:request_id"       => "requests#destroy"
  get     "/admin/requests/:request_id/edit"  => "requests#edit", as: "edit_admin_request"
  post    "/admin/requests/:request_id/edit"  => "requests#update"
  get     "/register"                         => "requests#new"
  post    "/register"                         => "requests#create"
  
  post "requests/approve"
  post "requests/reject"

  #users
  get  "/login"  => "users#login"
  post "/login"  => "users#authenticate"
  get  "/logout" => "users#logout"
  get  "/signup" => "users#new"

  #charities
  get "/charities/verify"
  get "/charities/search"
  get "/charities/domain_check"

  #pages
  get "/charities/:charity_id/" => "pages#show"

  resources :charities do
    resources :pages, :path => '' #removes the "pages" part of the url
  end

  resources :pages do
    resources :content
  end

  resources :admin do
    resources :requests
  end

  resources :users
end
