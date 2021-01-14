class Transaction < ApplicationRecord
  validates_presence_of :credit_card_number
  validates_date :credit_card_expiration_date
  belongs_to :invoice
  has_one :customer, through: :invoice
  has_many :invoice_items, through: :invoice
  has_many :items, through: :invoice_items

  enum result: [ :failed, :success ]
end
