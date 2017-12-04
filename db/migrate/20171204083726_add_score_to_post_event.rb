class AddScoreToPostEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :post_events, :score, :integer, default: 0
  end
end
