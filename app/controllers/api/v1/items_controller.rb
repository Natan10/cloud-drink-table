module Api
  module V1 
    class ItemsController < ApiController

      before_action :set_item, only: [:update,:destroy]
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordInvalid, with: :validation_user
      rescue_from ActiveRecord::RecordNotFound, with: :invalid_user

      def create 
        @item = Item.create!(item_params)
        render json: @item.to_json, status: :created
      end

      def update 
        @item.update!(item_params)
        head :ok
      end

      def destroy 
        @item.destroy
        head :ok
      end

      private 

      def item_params
        params.require(:item).permit(:name, :quantity,:price,:consumer_id)
      end

      def set_item
        @item = Item.find(params[:id])
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

