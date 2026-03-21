class CreateMarkets < ActiveRecord::Migration[7.2]
  def change
    create_table :markets do |t|
      t.string :title, null: false
      t.text :description
      t.string :market_type, default: 'binary', null: false
      t.string :status, default: 'open', null: false
      t.decimal :house_cut_pct, precision: 5, scale: 2, default: 5.0, null: false
      t.integer :creator_id, null: false
      t.integer :pool_id
      t.datetime :end_time, null: false
      t.integer :resolved_option_id
      t.string :subject_name
      t.decimal :total_pool, precision: 10, scale: 2, default: 0.0, null: false

      t.timestamps
    end
    add_index :markets, :status
    add_index :markets, :creator_id
  end
end
