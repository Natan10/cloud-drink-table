# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate_user, only: [:create]
      
      def create
        ::User::Create.call(user_params.to_h)
        .on_success{ |result| render_action_and_status(action: :create, user: result[:user], status: :created) }
        .on_failure(:user_create_error) { |result| render_error_msg(result[:errors]) }
      rescue ActionController::ParameterMissing => ex 
        render_error_msg(ex)
      end

      def update 
        ::User::Update.call(id: params[:id],params: user_params)
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
        user_view = { 
          id: user.id,
          username: user.username,
          email: user.email, 
          photo: user.photo.attached? ? rails_blob_path(user.photo,only_path: true) : nil 
        }
        render action ,locals: {user: user_view}, status: status
      end
      
      def render_error_msg(msg, status: :unprocessable_entity)
        render json: { error: msg }, status: status
      end
    end
  end
end
