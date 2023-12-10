class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :screen_name, null: false
      t.datetime :last_seen_at
      t.integer :posts_count, default: 0

      t.timestamps
    end
    add_index :users, :screen_name, unique: true
  end
end
