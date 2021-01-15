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
      @user = create(:user, role: 1)
      @merchant_2 = create(:merchant, user: @user)
      @user1 = create(:user, role: 1)
      @customer_23 = create(:customer, user: @user1)
      @invoice_33 = create(:invoice, merchant: @merchant_2, customer: @customer_23)
      @invoice_43 = create(:invoice, merchant: @merchant_2, customer: @customer_23)
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
  end

  describe "Class methods" do
    it '::with_enabled_merchants' do
      @user1 = create(:user, role: 1)
      @user2 = create(:user, role: 1)

      @merchant_1 = create(:merchant, user: @user1, status: 1)
      @merchant_2 = create(:merchant, user: @user2, status: 0)

      create_list(:item, 3, name: "xxx", merchant: @merchant_1)
      create_list(:item, 6, merchant: @merchant_2)

      expect(Item.with_enabled_merchants.count).to eq(3)
      expect(Item.with_enabled_merchants.first.name).to eq("xxx")
      expect(Item.with_enabled_merchants.second.name).to eq("xxx")
      expect(Item.with_enabled_merchants.third.name).to eq("xxx")
    end
  end
end
