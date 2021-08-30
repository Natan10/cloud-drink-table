class Product < ApplicationRecord
  belongs_to :restaurant
  has_one_attached :photo
  monetize :price_cents, numericality: {greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000}

end
