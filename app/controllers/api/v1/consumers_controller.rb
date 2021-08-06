module Api
  module V1
    class ConsumersController < ApiController
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordInvalid, with: :validation_user
      rescue_from ActiveRecord::RecordNotFound, with: :invalid_user
      before_action :set_consumer, only: [:show, :update, :destroy,:total_consumer]

      def show
        render :show
      end

      def create
        @consumer = Consumer.create!(consumer_params)
        render :create, status: :created
      end

      def update
        @consumer.update!(consumer_params)
        head :ok
      end

      def destroy
        @consumer.destroy
        head :ok
      end

      def total_consumer
        render :total_consumer
      end

      private

      def consumer_params
        params.require(:consumer).permit(:name, :total_consumed,:account_id)
      end

      def set_consumer
        @consumer = Consumer.find(params[:id])
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
