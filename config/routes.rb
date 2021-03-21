Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    scope module: :v1 do
      resources :users, only: [:create]
      resources :authentication, only: [:create]
    end
  end
end
