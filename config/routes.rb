Rails.application.routes.draw do
  resources :users

  get "/users/:id/check_admin", to: "users#check_admin"
  get "/books/total", to: "books#total"

  resources :books

  post "/newsession", to: "sessions#create"
  delete "/destroysession", to: "sessions#destroy"

  scope :format => true, :constraints => { :format => 'json' } do
    post   "/login"       => "sessions#create"
    delete "/logout"      => "sessions#destroy"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
