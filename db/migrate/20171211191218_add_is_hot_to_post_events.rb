class AddIsHotToPostEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :post_events, :is_hot, :boolean, default: false
  end
end
