class Account < ApplicationRecord
  belongs_to :user

  enum status: [:open, :closed]

  validates :total_account, numericality: {greater_than_or_equal_to: 0.0,
                                           less_than_or_equal_to: 999.999}
end
