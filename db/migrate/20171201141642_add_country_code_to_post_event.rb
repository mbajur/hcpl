class AddCountryCodeToPostEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :post_events, :country_code, :string
  end
end
