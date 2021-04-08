class Consumer < ApplicationRecord
  belongs_to :account

  monetize :total_consumed_cents,numericality: {greater_than_or_equal_to: 0,
                                               less_than_or_equal_to: 10000}

  validates_presence_of :name
end
