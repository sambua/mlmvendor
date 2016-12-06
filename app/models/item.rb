class Item < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  # status, slug, price, titkle, excerpt, description
  validates :status, :price, :title, :excerpt, :description, presence: true

end
