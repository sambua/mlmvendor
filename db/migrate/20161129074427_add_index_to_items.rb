class AddIndexToItems < ActiveRecord::Migration[5.0]
  def change
    add_index :items, :slug, unique: true
  end
end
