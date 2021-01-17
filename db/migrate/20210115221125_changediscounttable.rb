class Changediscounttable < ActiveRecord::Migration[5.2]
  def change
    remove_column :discounts, :percent
    add_column :discounts, :percentage, :float, default: 0.0
  end
end
