class InvoiceItem < ApplicationRecord
  belongs_to :item
  has_one :merchant, through: :item
  belongs_to :invoice
  has_one :user, through: :invoice
  has_many :transactions, through: :invoice

  validates :quantity, numericality: { only_integer: true }, presence: true
  validates :unit_price, numericality: true

  enum status: [ :pending, :packaged, :shipped ]

  def discount
    if discount_id != nil
      merchant.discounts.find(self.discount_id)
    else
      false
    end
  end
end
