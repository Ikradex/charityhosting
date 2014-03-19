CharitySystemManager::Application.routes.draw do
  root "welcome#index"

  #admin
  get "/admin/index"

  #admin/charities
  get  "/admin/charities"                  => "admin#charities_index", as: "admin_charities"
  get  "/admin/charities/:charity_id"      => "admin#charity_show",    as: "admin_charity"
  get  "/admin/charities/:charity_id/edit" => "charities#edit",        as: "edit_admin_charity" 
  post "/admin/charities/:charity_id/edit" => "charities#update"

  get  "charities/validate" => "admin#validate_charity", as: "charity_validate"
  post "charities/validate" => "admin#validate_charity"

  #requests
  get    "/admin/requests"                  => "requests#index"
  get    "/admin/requests/:request_id"      => "requests#show", as: "admin_request" 
  delete "/admin/requests/:request_id"      => "requests#destroy"
  get    "/admin/requests/:request_id/edit" => "requests#edit", as: "edit_admin_request"
  post   "/admin/requests/:request_id/edit" => "requests#update"
  get    "/register"                        => "requests#new"
  post   "/register"                        => "requests#create"
  
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

  get "/charities/:charity_id/"      => "charities#show"
  get "/charities/:charity_id/index" => "charities#show"

  #donations
  get "/charities/:charity_id/donate" => "charges#new", as: "donate_charity"

  #lost and found
  get "/charities/:charity_id/lost_and_found" => "charities#lost_and_found", as: "charity_lost_and_found"

  #pages

  #animals
  get "/charities/:charity_id/animals/:animal_id/adopt" => "animals#adopt", as: "adopt_charity_animal"

  resources :charities do
    resources :animals
    resources :posts
    resources :pages, :path => 'p' #removes the "pages" part of the url
    resources :charges
  end

  resources :pages do
    resources :content
  end

  resources :admin do
    resources :requests
  end

  resources :users
end
