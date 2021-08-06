module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate_user, only: [:create]
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordInvalid, with: :validation_error

      def create
        @user = User.create!(user_params)
        render :create , status: :created
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation,:photo)
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
