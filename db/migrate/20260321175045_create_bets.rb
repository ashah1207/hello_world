class CreateBets < ActiveRecord::Migration[7.2]
  def change
    create_table :bets do |t|
      t.integer :user_id, null: false
      t.integer :market_id, null: false
      t.integer :market_option_id, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.boolean :anonymous, default: false, null: false
      t.decimal :payout_amount, precision: 10, scale: 2
      t.boolean :settled, default: false, null: false

      t.timestamps
    end
    add_index :bets, [:user_id, :market_id]
  end
end
