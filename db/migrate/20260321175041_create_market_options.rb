class CreateMarketOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :market_options do |t|
      t.integer :market_id, null: false
      t.string :label, null: false
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0, null: false

      t.timestamps
    end
    add_index :market_options, :market_id
  end
end
