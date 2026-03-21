class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :blacklisted, default: false, null: false
      t.boolean :anonymous_default, default: false, null: false
      t.decimal :balance, precision: 10, scale: 2, default: 100.00, null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
