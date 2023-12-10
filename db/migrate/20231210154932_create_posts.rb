class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :comments_count, default: 0

      t.timestamps
    end
    add_index :posts, :title, unique: true
  end
end
