require 'rails_helper'

describe Discount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoice_items).through(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_numericality_of :percentage }
    it { should validate_numericality_of :minimum }
  end

  describe 'instance methods' do
    it 'can check for pending invoice items' do
      @user = create(:user)
      @merchant = create(:merchant, user: @user)
      @user1 = create(:user)
      @invoice_1 = create(:invoice, user: @user1, status: 0, created_at: "2012-01-25 09:54:09")
      item1 = create(:item, unit_price: 20, merchant: @merchant)
      item2 = create(:item, unit_price: 30, merchant: @merchant)
      discount = create(:discount, merchant: @merchant, minimum: 3, percentage: 50)
      discount2 = create(:discount, merchant: @merchant, minimum: 3, percentage: 50)
      invoice = Invoice.create(user: @user, status: 1)
      invoice_item1 = InvoiceItem.create(invoice: invoice, quantity: 1, item: item1, unit_price: item1.unit_price)
      invoice_item2 = InvoiceItem.create(invoice: invoice, status: 0, discount_id: discount.id, quantity: 5, item: item1, unit_price: item1.unit_price)

      expect(discount.pending_invitems?).to eq(true)
      expect(discount2.pending_invitems?).to eq(false)

      newdiscount = Discount.new(name: "discount", merchant: @merchant, minimum: 5, percentage: 10)

      expect(newdiscount.better_discount?).to eq(true)
    end
  end
end
