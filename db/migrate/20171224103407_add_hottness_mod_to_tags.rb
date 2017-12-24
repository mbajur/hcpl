class AddHottnessModToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :hottness_mod, :decimal, default: 0
  end
end
