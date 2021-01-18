require 'rails_helper'

RSpec.describe Item, type: :model do

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price}
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'instance methods' do
    it '#best day' do
      @user = create(:user)
      @merchant_2 = create(:merchant, user: @user)
      @user1 = create(:user)
      @invoice_33 = create(:invoice, user: @user1)
      @invoice_43 = create(:invoice, user: @user1)
      create(:transaction, result: 1, invoice: @invoice_33)
      create(:transaction, result: 0, invoice: @invoice_43)

      create_list(:item, 6, merchant: @merchant_2)

      create(:invoice_item, item: @merchant_2.items.fourth, invoice: @invoice_33, quantity: 10, unit_price: 2)#60
      1.times do
        create(:invoice_item, item: @merchant_2.items.first, invoice: @invoice_33, quantity: 10, unit_price: 3)#30
      end

      3.times do
        create(:invoice_item, item: @merchant_2.items.second, invoice: @invoice_33, quantity: 10, unit_price: 4)#120
      end
        create(:invoice_item, item: @merchant_2.items.third, invoice: @invoice_33, quantity: 10, unit_price: 6)#60
        create(:invoice_item, item: @merchant_2.items.fifth, invoice: @invoice_33, quantity: 10, unit_price: 1)#60
      2.times do
        create(:invoice_item, item: @merchant_2.items.third, invoice: @invoice_43, quantity: 10, unit_price: 6)
      end

      expected = [@merchant_2.items.second, @merchant_2.items.third, @merchant_2.items.first, @merchant_2.items.fourth, @merchant_2.items.fifth]
      expect(@merchant_2.items.fourth.best_day).to eq(@invoice_33.date)
    end

    it 'might have discounts' do
      @user = create(:user)
      @merchant = create(:merchant, user: @user)
      @user2 = create(:user)
      @merchant1 = create(:merchant, user: @user2)
      @user1 = create(:user)
      @invoice_1 = create(:invoice, user: @user1, status: 0, created_at: "2012-01-25 09:54:09")
      item1 = create(:item, unit_price: 20, merchant: @merchant)
      item2 = create(:item, unit_price: 30, merchant: @merchant1)
      discount = create(:discount, merchant: @merchant, minimum: 3, percentage: 50)
      invoice = Invoice.create(user: @user, status: 1)
      invoice_item1 = InvoiceItem.create(invoice: invoice, quantity: 1, item: item1, unit_price: item1.unit_price)
      invoice_item2 = InvoiceItem.create(invoice: invoice, discount_id: discount.id, quantity: 5, item: item1, unit_price: item1.unit_price)


      expect(item1.discounts?).to eq(true)
      expect(item2.discounts?).to eq(false)
    end

    it 'can show best_discount' do
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


      expect(item1.best_discount(5)).to eq(discount)
    end
  end
end
