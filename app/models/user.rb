class User < ApplicationRecord
  validates :email, :username, :password_hash, presence: true
end
