class CreateReports < ActiveRecord::Migration[7.2]
  def change
    create_table :reports do |t|
      t.integer :market_id, null: false
      t.integer :reporter_id, null: false
      t.text :reason, null: false
      t.string :status, default: 'pending', null: false

      t.timestamps
    end
  end
end
