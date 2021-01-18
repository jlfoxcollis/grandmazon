require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
  end

  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :invoice}
    it {should have_one(:merchant).through(:item) }
    it {should have_one(:user).through(:invoice) }
    it {should have_many(:transactions).through(:invoice) }
  end

  describe 'instance methods' do
    it 'can have a discount' do
      @user = create(:user)
      @merchant = create(:merchant, user: @user)
      @user1 = create(:user)
      @invoice_1 = create(:invoice, user: @user1, status: 0, created_at: "2012-01-25 09:54:09")
      item1 = create(:item, unit_price: 20, merchant: @merchant)
      item2 = create(:item, unit_price: 30, merchant: @merchant)
      discount = create(:discount, merchant: @merchant, minimum: 3, percentage: 50)
      invoice = Invoice.create(user: @user, status: 1)
      invoice_item1 = InvoiceItem.create(invoice: invoice, quantity: 1, item: item1, unit_price: item1.unit_price)
      invoice_item2 = InvoiceItem.create(invoice: invoice, discount_id: discount.id, quantity: 5, item: item1, unit_price: item1.unit_price)

      expect(invoice.invoice_items.first.discount).to eq(false)
      expect(invoice.invoice_items.second.discount).to eq(discount)
    end

  end

  describe 'class methods' do
  end

end
