class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.integer :status, :limit => 1, :default => 0
      t.string :slug,    null: false
      t.float :price,    :precision => 6, scale: 2, :null => false
      t.string :title,   :limit => 200, :null => false
      t.string :excerpt, :limit => 200
      t.text :description

      t.timestamps
    end
  end
end
