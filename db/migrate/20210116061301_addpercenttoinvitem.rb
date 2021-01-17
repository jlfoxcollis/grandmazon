class Addpercenttoinvitem < ActiveRecord::Migration[5.2]
  def change
    add_column :invoice_items, :discount_percent, :integer
  end
end
