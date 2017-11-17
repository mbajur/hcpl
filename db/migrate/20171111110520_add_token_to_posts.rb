class AddTokenToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :token, :string
    add_index :posts, :token, unique: true
  end
end
