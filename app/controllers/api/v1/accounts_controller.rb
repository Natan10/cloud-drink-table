module Api
  module V1
    class AccountsController < ApiController
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordInvalid, with: :validation_user

      before_action :set_account, only: [:destroy]

      def index
        @accounts = Account.where(user_id: @current_user.id)
        render json: {accounts: @accounts.to_json(only: [:id, :status, :description])}
      end

      def create
        @account = Account.create!(account_params)
        render json: @account.to_json(only: [:id, :status, :description, :total_account_cents, :user_id]),
               status: :created
      end

      def destroy
        @account.update(status: "closed")
        head :ok
      end

      private

      def set_account
        @account = Account.find(params[:id])
        @account
      end

      def account_params
        params.require(:account).permit(:total_account_cents, :status, :description, :user_id)
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
