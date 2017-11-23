class AddSyncedAtToPostEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :post_events, :synced_at, :datetime
  end
end
