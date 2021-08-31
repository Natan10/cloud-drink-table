class Restaurant < ApplicationRecord
  has_many :products,dependent: :destroy
  has_one_attached :logo 

  accepts_nested_attributes_for :products
end
