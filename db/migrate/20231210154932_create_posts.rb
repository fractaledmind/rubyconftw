class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.datetime :published_at
      t.integer :comments_count

      t.timestamps
    end
    add_index :posts, :title, unique: true
  end
end
