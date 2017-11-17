class CreatePostEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :post_events do |t|
      t.datetime :beginning_at
      t.string :city
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
