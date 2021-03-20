module Api
  module V1
    class AuthenticationController < ApiController
      class AuthenticationError < StandardError;end

      rescue_from AuthenticationError, with: :handle_unauthenticated
      def create
  
        user = User.find_by(email: params[:user][:email])
        raise AuthenticationError unless user.authenticate(params[:user][:password])
        token = AuthenticationTokenService.encode(user.id)

        render json: {token: token}, status: :created
      end

      private

      def handle_unauthenticated
        head :unauthorized
      end
    end
  end
end
