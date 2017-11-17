class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :link
      t.text :description
      t.integer :votes_count, default: 0
      t.integer :comments_count, default: 0

      t.timestamps
    end
    add_index :posts, :link, unique: true
  end
end
