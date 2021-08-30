module Api
  module V1
    class RestaurantsController < ApiController
      skip_before_action :authenticate_user
      before_action :set_restaurant, only: [:update, :destroy]
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordInvalid, with: :validation_user
      rescue_from ActiveRecord::RecordNotFound, with: :invalid_user

      def index 
        @restaurants = Restaurant.all
        render :index
      end
      
      def create
        @restaurant = Restaurant.create!(restaurant_params)
        render :create, status: :created
      end

      def update
        @restaurant.update!(restaurant_params)
        head :ok
      end

      def destroy
        @restaurant.destroy
        head :ok
      end

      private

      def restaurant_params
        params.require(:restaurant).permit(:name,:logo)
      end

      def set_restaurant
        @restaurant = Restaurant.find(params[:id])
      end

      def parameter_missing(e)
        render json: {
          error: e.message
        }, status: :unprocessable_entity
      end

      def validation_user(e)
        render json: {
          error: e.message
        }, status: :unprocessable_entity
      end

      def invalid_user(e)
        render json: {
          error: e.message
        }, status: :not_found
      end
    end
  end
end
