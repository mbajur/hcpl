class AddAttendantsToPostEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :post_events, :attendants_count, :integer, default: 0
  end
end
