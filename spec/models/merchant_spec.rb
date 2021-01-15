require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name}
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should belong_to :user}
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:users).through(:invoices) }
  end

  describe 'class methods' do
    before :each do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      @user4 = create(:user)
      @merchant = create(:merchant, status: 0, user: @user1)
      @merchant1 = create(:merchant, status: 0, user: @user2)
      @merchant2 = create(:merchant, status: 0, user: @user3)
      @merchant3 = create(:merchant, status: 1, user: @user4)
    end
    it '::enabled' do
      expect(Merchant.enabled.first.name).to eq(@merchant3.name)
    end
    it '::disabled' do
      expect(Merchant.disabled).to eq([@merchant, @merchant1, @merchant2])
    end
    it '::top_5_revenue' do
      @user5 = create(:user)
      @user6 = create(:user)
      @user7 = create(:user)
      @user8 = create(:user)
      @merchant4 = create(:merchant, name: '4', user: @user5)
      @merchant5 = create(:merchant, name: '5', user: @user6)
      @merchant6 = create(:merchant, name: '6', user: @user7)
      @merchant7 = create(:merchant, name: '7', user: @user8)
      @user43 = create(:user)

      invoice1 = create(:invoice, user: @user43)
      invoice2 = create(:invoice, user: @user43)
      invoice3 = create(:invoice, user: @user43)
      invoice4 = create(:invoice, user: @user43)
      invoice5 = create(:invoice, user: @user43)
      invoice6 = create(:invoice, user: @user43)
      invoice7 = create(:invoice, user: @user43)

      transaction1 = create(:transaction, invoice: invoice1, result: 1)
      transaction2 = create(:transaction, invoice: invoice2, result: 1)
      transaction3 = create(:transaction, invoice: invoice3, result: 1)
      transaction4 = create(:transaction, invoice: invoice4, result: 1)
      transaction5 = create(:transaction, invoice: invoice5, result: 1)
      transaction6 = create(:transaction, invoice: invoice6, result: 1)
      transaction7 = create(:transaction, invoice: invoice7, result: 0)

      item1 = create(:item, merchant: @merchant1)
      item2 = create(:item, merchant: @merchant2)
      item3 = create(:item, merchant: @merchant3)
      item4 = create(:item, merchant: @merchant4)
      item5 = create(:item, merchant: @merchant5)
      item6 = create(:item, merchant: @merchant6)
      item7 = create(:item, merchant: @merchant7)

      invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 1, unit_price: 300) #300 rev
      invoice_item2 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 2, unit_price: 15) #30 rev
      invoice_item3 = create(:invoice_item, item: item3, invoice: invoice3, quantity: 2, unit_price: 40) # 80 rev
      invoice_item4 = create(:invoice_item, item: item4, invoice: invoice4, quantity: 4, unit_price: 50) # 200 rev
      invoice_item5 = create(:invoice_item, item: item5, invoice: invoice5, quantity: 10, unit_price: 10) # 100 rev
      invoice_item6 = create(:invoice_item, item: item6, invoice: invoice6, quantity: 4, unit_price: 30) # 120 rev
      invoice_item7 = create(:invoice_item, item: item7, invoice: invoice7, quantity: 10, unit_price: 5) # 50 rev
      invoice_item8 = create(:invoice_item, item: item7, invoice: invoice7, quantity: 1, unit_price: 110) # 110 rev

      expect(Merchant.top_5_merchants).to eq([@merchant1, @merchant4, @merchant6, @merchant5, @merchant3])
    end
  end

  describe 'instance methods' do
    describe 'environment for top 5 users and ready-to-ship' do
      before :each do
        @user9 = create(:user)
        @merchant = create(:merchant, user: @user9)

        @user43 = create(:user)
        @invoice_1 = create(:invoice, user: @user43)
        @invoice_2 = create(:invoice, user: @user43)
        create(:transaction, result: 1, invoice: @invoice_1)
        create(:transaction, result: 1, invoice: @invoice_2)

        @user44 = create(:user)
        @invoice_3 = create(:invoice, user: @user44)
        @invoice_4 = create(:invoice, user: @user44)
        create(:transaction, result: 1, invoice: @invoice_3)
        create(:transaction, result: 1, invoice: @invoice_3)
        create(:transaction, result: 1, invoice: @invoice_3)
        create(:transaction, result: 1, invoice: @invoice_4)

        @user45 = create(:user)
        @invoice_5 = create(:invoice,user: @user45)
        @invoice_6 = create(:invoice,user: @user45)
        create(:transaction, result: 1, invoice: @invoice_5)
        create(:transaction, result: 1, invoice: @invoice_5)
        create(:transaction, result: 1, invoice: @invoice_6)

        @user46 = create(:user)
        @invoice_7 = create(:invoice, user: @user46)
        create(:transaction, result: 1, invoice: @invoice_7)
        create(:transaction, result: 1, invoice: @invoice_7)
        create(:transaction, result: 1, invoice: @invoice_7)
        create(:transaction, result: 1, invoice: @invoice_7)
        create(:transaction, result: 1, invoice: @invoice_7)

        @user47 = create(:user)
        @invoice_8 = create(:invoice, user: @user47)
        create(:transaction, result: 0, invoice: @invoice_7)

        @user48 = create(:user)
        @invoice_9 = create(:invoice, user: @user48)
        @invoice_10 = create(:invoice, user: @user48)
        create(:transaction, result: 1, invoice: @invoice_9)

        create_list(:item, 3, merchant: @merchant)

        5.times do
          create(:invoice_item, item: Item.first, invoice: @invoice_9, status: 1)
          create(:invoice_item, item: Item.first, invoice: @invoice_8, status: 1)
          create(:invoice_item, item: Item.first, invoice: @invoice_7, status: 2)
          create(:invoice_item, item: Item.first, invoice: @invoice_6, status: 2)
          create(:invoice_item, item: Item.first, invoice: @invoice_5, status: 2)
          create(:invoice_item, item: Item.first, invoice: @invoice_4, status: 2)
          create(:invoice_item, item: Item.first, invoice: @invoice_3, status: 2)
          create(:invoice_item, item: Item.first, invoice: @invoice_2, status: 2)
          create(:invoice_item, item: Item.first, invoice: @invoice_1, status: 2)
        end
      end
      it '#top_5_users' do
        expect(@merchant.users.distinct.count).to eq(6)
        top = [@user46.first_name, @user44.first_name, @user45.first_name, @user43.first_name, @user48.first_name]
        actual = @merchant.top_5.map { | x | x[:first_name]}
        expect(actual).to eq(top)
      end

      it '#ready_to_ship' do
        expected = @merchant.ready_to_ship
        expect(expected.length).to eq(10)
      end

      it '#best_day', :skip_before do
        @user = create(:user)
        @merchant = create(:merchant, user: @user)
        @user50 = create(:user)
        @item_1 = create(:item, merchant: @merchant)

        @invoice_1 = create(:invoice, user: @user50, status: 0, created_at: "2012-01-25 09:54:09")
        @invoice_2 = create(:invoice, user: @user50, status: 1, created_at: "2012-02-25 09:54:09")
        @invoice_3 = create(:invoice, user: @user50, status: 2, created_at: "2012-03-25 09:54:09")

        @transaction1 = create(:transaction, invoice: @invoice_1, result: 1)
        @transaction2 = create(:transaction, invoice: @invoice_2, result: 1)
        @transaction3 = create(:transaction, invoice: @invoice_3, result: 1)

        @invoice_item_1 = create(:invoice_item, status: 0, item: @item_1, invoice: @invoice_1, unit_price: 300, quantity: 1)
        @invoice_item_2 = create(:invoice_item, status: 0, item: @item_1, invoice: @invoice_2, unit_price: 100, quantity: 1)
        @invoice_item_3 = create(:invoice_item, status: 0, item: @item_1, invoice: @invoice_3, unit_price: 200, quantity: 1)

        expect(@merchant.best_day).to eq(@invoice_1.date)
      end

      it '#top_5_items', :skip_before do
        @user = create(:user)
        @merchant_2 = create(:merchant, user: @user)
        @user51 = create(:user)
        @invoice_33 = create(:invoice, user: @user51)
        @invoice_43 = create(:invoice, user: @user51)
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
        expect(@merchant_2.top_5_items).to eq(expected)
      end
    end
  end
end
