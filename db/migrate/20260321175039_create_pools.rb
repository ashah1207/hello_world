class CreatePools < ActiveRecord::Migration[7.2]
  def change
    create_table :pools do |t|
      t.string :name, null: false
      t.string :pool_type, default: 'public', null: false
      t.integer :creator_id, null: false
      t.string :invite_code

      t.timestamps
    end
  end
end
