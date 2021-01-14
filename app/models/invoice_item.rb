class InvoiceItem < ApplicationRecord
  belongs_to :item
  has_one :merchant, through: :item
  belongs_to :invoice
  has_one :customer, through: :invoice
  has_many :transactions, through: :invoice

  enum status: [ :pending, :packaged, :shipped ]

end
