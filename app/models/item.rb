class Item < ApplicationRecord
  belongs_to :consumer

  monetize :price_cents,numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1000
  }
  
  validates_presence_of :name
  validates :quantity, numericality: {
    only_integer: true, 
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }

   
  def total_price 
    quantity * price_cents
  end

end
