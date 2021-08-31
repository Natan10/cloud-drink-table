module Api
  module V1
    class ProductsController < ApiController
      skip_before_action :authenticate_user
      before_action :set_product, only: [:update, :destroy]
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordInvalid, with: :validation_user
      rescue_from ActiveRecord::RecordNotFound, with: :invalid_user

      
      def create
        @product = Product.create!(product_params)
        head :created
      end

      def update
        @product.update!(product_params)
        head :ok
      end

      def destroy
        @product.destroy
        head :ok
      end

      private

      def product_params
        params.require(:product)
        .permit(:name,:description,:price,:restaurant_id,:photo)
      end

      def set_product
        @product = Product.find(params[:id])
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
