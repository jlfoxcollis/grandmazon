class Createmerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.string :name
      t.integer :status, default: 1
      t.references :user, foreign_key: true
      t.timestamps
    end

    create_table :items do |t|
      t.string :name
      t.string :description
      t.integer :unit_price
      t.integer :status, default: 0
      t.references :merchant, foreign_key: true

      t.timestamps
    end

    create_table :invoice_items do |t|
      t.integer :quantity
      t.integer :unit_price
      t.integer :status, default: 0
      t.references :item, foreign_key: true
      t.references :invoice, foreign_key: true

      t.timestamps
    end
  end
end
