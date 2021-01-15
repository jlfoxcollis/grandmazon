class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :discount_items, dependent: :nullify
  has_many :items, through: :discount_items
  has_many :invoice_items, through: :items


end
