class AddIsPrimaryToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :is_primary, :boolean, default: true
  end
end
