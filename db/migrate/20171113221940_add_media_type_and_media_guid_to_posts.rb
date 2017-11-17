class AddMediaTypeAndMediaGuidToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :media_type, :string
    add_column :posts, :media_guid, :string
  end
end
