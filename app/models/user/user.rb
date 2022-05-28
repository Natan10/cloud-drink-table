module User 
  class User < ApplicationRecord
    has_secure_password
    has_one_attached :photo
    has_many :accounts, dependent: :destroy

    validates :email,
      presence: true,
      uniqueness: true,
      format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}
    validates :username, presence: true, uniqueness: true
  end
end 
