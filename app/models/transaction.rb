class Transaction < ApplicationRecord
  validates_presence_of :credit_card_number
  validates_presence_of :credit_card_expiration_date
  belongs_to :invoice
  has_one :user, through: :invoice
  has_many :invoice_items, through: :invoice
  has_many :items, through: :invoice_items

  enum result: [ :failed, :success ]
end
