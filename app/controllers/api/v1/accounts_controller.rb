module Api
  module V1
    class AccountsController < ApiController
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordInvalid, with: :validation_user
      rescue_from ActiveRecord::RecordNotFound, with: :invalid_account

      before_action :set_account, only: [:destroy, :account_total]

      def index
        @accounts = Account.where(user_id: @current_user.id)
        render :index
      end

      def create
        @account = Account.create!(create_params)
        render :create, status: :created
      end

      def destroy
        @account.update(status: "closed")
        head :ok
      end

      def account_total
        render :account_total
      end

      private

      def set_account
        @account = Account.find(params[:id])
        @account
      end

      def account_params
        params.require(:account).permit(:total_account_cents, :status, :description)
      end

      def create_params
        account_params.merge(user_id: params[:user_id])
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

      def invalid_account(e)
        render json: {
          error: e.message
        }, status: :not_found
      end
    end
  end
end
