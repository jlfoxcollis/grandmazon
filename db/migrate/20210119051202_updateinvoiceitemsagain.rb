class Updateinvoiceitemsagain < ActiveRecord::Migration[5.2]
  def change
    remove_column :invoice_items, :discount_percent
    add_column :invoice_items, :discount_percent, :decimal, precision: 5, scale: 2
    remove_column :discounts, :percentage
    add_column :discounts, :percentage, :decimal, precision: 5, scale: 2
  end
end
