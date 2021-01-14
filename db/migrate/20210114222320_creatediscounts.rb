class Creatediscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :minimum, default: 0
      t.float :percent, default: 1.0
      t.references :merchant, foreign_key: true
      t.timestamps
    end
  end
end
