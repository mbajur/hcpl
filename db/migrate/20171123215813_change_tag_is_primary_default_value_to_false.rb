class ChangeTagIsPrimaryDefaultValueToFalse < ActiveRecord::Migration[5.1]
  def change
    change_column :tags, :is_primary, :boolean, default: false
  end
end
