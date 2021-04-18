Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    scope module: :v1 do
      resources :users, only: [:create] do
        resources :accounts, only: [:index, :create, :destroy] do
          member do 
            get :account_total
          end
          resources :consumers, only: [:show, :create, :update, :destroy] do
            resources :items, only: [:create, :update, :destroy]
          end
        end
      end

      resources :authentication, only: [:create]
    end
  end
end
