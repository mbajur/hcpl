class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :country_code
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
