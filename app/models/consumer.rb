class Consumer < ApplicationRecord
  belongs_to :account
  has_many :items

  monetize :total_consumed_cents, numericality: {greater_than_or_equal_to: 0,
                                                 less_than_or_equal_to: 100000}

  validates_presence_of :name

  def total_consumer 
    total_consumed = self.items.reduce(0) do |sum,num| 
      sum + num.total_price
    end
  end
end
