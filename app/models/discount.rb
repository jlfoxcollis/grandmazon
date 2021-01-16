class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  validates_presence_of :name
  validates_presence_of :percentage, :minimum, numericality: true



end
