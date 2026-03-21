class CreatePoolMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :pool_memberships do |t|
      t.integer :user_id
      t.integer :pool_id

      t.timestamps
    end
  end
end
