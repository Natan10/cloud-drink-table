class Account < ApplicationRecord
  belongs_to :user

  enum status: [:open, :closed]

end
