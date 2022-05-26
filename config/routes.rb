Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    scope module: :v1 do
      
      post '/users', to: 'users#create'
      put '/users/:id', to: 'users#update', as: 'user'

      resources :accounts, only: [:index, :create, :destroy] do
        member do
          get :account_total
        end
      end
      resources :consumers, only: [:show, :create, :update, :destroy] do
        member do 
          get :total_consumer
        end
      end

      resources :restaurants, only: [:index,:create,:update,:destroy,:show] 
      resources :products, only: [:create,:update,:destroy] 

      resources :items, only: [:create, :update, :destroy]
      
      resources :authentication, only: [:create]
    end
  end
end
