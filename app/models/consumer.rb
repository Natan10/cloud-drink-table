class Consumer < ApplicationRecord
  belongs_to :account

  validates_presence_of :name
  validates :total_consumed, numericality: {greater_than_or_equal_to: 0.0,
                                            less_than_or_equal_to: 999.999}
end
