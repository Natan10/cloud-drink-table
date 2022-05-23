# frozen_string_literal: true
module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate_user, only: [:create]
      
      def create
        UserCases::Create.call(user_params.to_h)
        .on_success{ |result| render_action_and_status(action: :create, user: result[:user], status: :created) }
        .on_failure(:parameter_missing) { |result| render_error_msg(result[:msg]) }
        .on_failure(:username_empty) { |_| render_error_msg('username was not passed!') } 
        .on_failure(:email_empty) { |_| render_error_msg('email was not pass!') } 
        .on_failure(:password_empty) { |_| render_error_msg('password was not pass!') } 
        .on_failure(:password_confirmation_empty) { |_| render_error_msg('password_confirmation was not pass!') } 
        .on_failure(:password_error) { |_| render_error_msg('password and password_confirmation different!') } 
      rescue ActionController::ParameterMissing => ex 
        render_error_msg(ex)
      end

      def update 
        UserCases::Update.call(id: params[:id],params: user_params)
        .on_success { |result| render_action_and_status(action: :update,user: result[:user], status: :ok) }
        .on_failure(:user_not_found) { |result| render_error_msg(result[:msg], status: :not_found)}
        .on_failure(:parameter_missing) { |result| render_error_msg(result[:msg]) }
      rescue ActionController::ParameterMissing => ex 
        render_error_msg(ex)
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation,:photo)
      end

      def render_action_and_status(action: , user:, status:)
        render action ,locals: {user: user}, status: status
      end
      
      def render_error_msg(msg, status: :unprocessable_entity)
        render json: { error: msg }, status: status
      end
    end
  end
end
