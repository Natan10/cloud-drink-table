Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    scope module: :v1 do
      resources :users, only: [:create] do
        resources :accounts, only: [:index, :create, :destroy] do
          resources :consumers, only: [:show, :create, :update, :destroy] do
            resources :items, only: [:create, :update, :destroy]
          end
        end
      end

      # resources :users, only: [:create]
      # resources :accounts, only: [:index, :create, :destroy]
      # resources :consumers, only: [:show, :create, :update, :destroy]
      # resources :items, only: [:create, :update, :destroy]

      resources :authentication, only: [:create]
    end
  end
end
