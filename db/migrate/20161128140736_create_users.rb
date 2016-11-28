class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :status, :limit => 1, default: 0
      t.string :username, :null => false
      t.string :email, :null => false
      t.string :password_hash, :null => false

      t.timestamps
    end
  end
end
