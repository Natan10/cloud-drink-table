module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate_user, only: [:create]
      before_action :set_user, only: [:update]
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordInvalid, with: :validation_error
      rescue_from ActiveRecord::RecordNotFound, with: :invalid_user


      def create
        @user = User.create!(user_params)
        render :create , status: :created
      end

      def update 
        @user.update!(user_params)
        render :update, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation,:photo)
      end

      def set_user  
        @user = User.find(params[:id])
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

      def invalid_user(e)
        render json: {
          error: e.message
        }, status: :not_found
      end
    end
  end
end
