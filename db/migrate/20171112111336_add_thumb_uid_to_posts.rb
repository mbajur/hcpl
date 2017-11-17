class AddThumbUidToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :thumb_uid, :string
  end
end
