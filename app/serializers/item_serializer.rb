class ItemSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :status, :description, :excerpt, :created_at
end
