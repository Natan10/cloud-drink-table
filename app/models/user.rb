class User < ApplicationRecord
  has_secure_password
  has_many :accounts

  validates :email,
    presence: true,
    uniqueness: true,
    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}
  validates :username, presence: true, uniqueness: true
end
