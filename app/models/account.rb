class Account < ApplicationRecord
  belongs_to :user
  has_many :consumers, dependent: :destroy

  enum status: [:open, :closed]

  monetize :total_account_cents, numericality: {greater_than_or_equal_to: 0,
                                                less_than_or_equal_to: 100000}

  def account_total
    total_account = consumers.reduce(0) do |sum, consumer|
      sum += consumer.total_consumer
    end
  end
end
