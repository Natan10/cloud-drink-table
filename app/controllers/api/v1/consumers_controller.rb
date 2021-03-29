module Api
  module V1
    class ConsumersController < ApiController

      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordInvalid, with: :validation_user

      def create 
        @consumer = Consumer.create!(consumer_params)
        render json: @consumer, status: :created
      end

      private 

      def consumer_params
        params.require(:consumer).permit(:name,:total_consumed,:account_id)
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
    end
  end
end