class Account < ApplicationRecord
  belongs_to :user
  has_many :consumers

  enum status: [:open, :closed]

  monetize :total_account_cents, numericality: {greater_than_or_equal_to: 0,
                                                less_than_or_equal_to: 100000}
end
