class Restaurant < ApplicationRecord
  has_many :products,dependent: :destroy
  has_one_attached :logo 
end
