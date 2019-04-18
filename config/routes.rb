Rails.application.routes.draw do
  root to: "homepages#index"
  # get 'homepages/index'
  resources :trips, only: [:delete, :update, :create]

  # In the instructor example, show, new, and edit are all only in passenger. (also, new button on on passenger in reqs.)
  # Do we want to do that?

  resources :drivers do
    resources :trips, only: [:show, :new, :edit]
  end

  resources :passengers do
    resources :trips, only: [:show, :new, :edit]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
