class AddPosterUidToPostEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :post_events, :poster_uid, :string
  end
end
