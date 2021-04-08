class Account < ApplicationRecord
  belongs_to :user

  enum status: [:open, :closed]
  
  monetize :total_account_cents,numericality: {greater_than_or_equal_to: 0,
    less_than_or_equal_to: 10000}

end
