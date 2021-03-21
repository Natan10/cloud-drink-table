module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate_user
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordInvalid, with: :validation_error
      
      def create
        User.create!(user_params)
        head :created
      end

      private 

      def user_params 
        params.require(:user).permit(:username,:email,:password,:password_confirmation)
      end

      def parameter_missing(e)
        render json: {
          error: e.message
        }, status: :unprocessable_entity
      end
      
      def validation_error(e)
        render json: {
          error: e.message
        }, status: :unprocessable_entity
      end
    end
  end
end

