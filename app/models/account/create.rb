module Account
  class Create < ::Micro::Case
    attribute :total_account_cents
    attribute :status
    attribute :description
    attribute :user_id


    def call!
      account = Account.new(
        total_account_cents: total_account_cents || 0,
        status: status,
        description: description,
        user_id: user_id
      )

      if account.save
        
        return Success(:create_account, result: { account: account })
      end

      Failure :account_create_error, result: { errors: account.errors.messages }
    end
  end
end