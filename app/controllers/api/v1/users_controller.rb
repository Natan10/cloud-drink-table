module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate_user, only: [:create]
      before_action :set_user, only: [:update]
      
      rescue_from ActiveRecord::RecordInvalid, with: :validation_error
      rescue_from ActiveRecord::RecordNotFound, with: :invalid_user


      def create
        UserCases::Create.call(user_params.to_h)
        .on_success{ |result| render_action_and_status(result[:user]) }
        .on_failure(:parameter_missing) { |result| render_parameter_missing(result[:msg]) }
        .on_failure(:username_empty) { |_| render_error_msg('username was not passed!') } 
        .on_failure(:email_empty) { |_| render_error_msg('email was not pass!') } 
        .on_failure(:password_empty) { |_| render_error_msg('password was not pass!') } 
        .on_failure(:password_confirmation_empty) { |_| render_error_msg('password_confirmation was not pass!') } 
        .on_failure(:password_error) { |_| render_error_msg('password and password_confirmation different!') } 
      rescue ActionController::ParameterMissing => ex 
        render_parameter_missing(ex)
      end

      def update 
        @user.update!(user_params)
        render :update, status: :ok
      rescue ActionController::ParameterMissing => ex 
        render_parameter_missing(ex)
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation,:photo)
      end

      def render_action_and_status(user)
        @user = user
        render :create, status: :created
      end

      def render_error_msg(msg)
        render json: { error: msg }, status: :unprocessable_entity
      end


      def render_parameter_missing(msg)
        render json: { error: msg }, status: :unprocessable_entity
      end

      def validation_error(e)
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def invalid_user(e)
        render json: { error: e.message }, status: :not_found
      end
    end
  end
end
