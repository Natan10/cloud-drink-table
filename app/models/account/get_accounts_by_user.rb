# frozen_string_literal: true

module Account
  class GetAccountsByUser < ::Micro::Case
    attribute :user_id

    def call!
      accounts = Account.where(user_id: user_id)
      Success result: {accounts: accounts}    
    end
  end
end