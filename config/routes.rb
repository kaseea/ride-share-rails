Rails.application.routes.draw do
  root to: "homepages#index"
  # get 'homepages/index'

  resources :trips
  resources :drivers
  resources :passengers

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
