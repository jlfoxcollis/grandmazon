require 'rails_helper'

RSpec.describe 'merchants items show page', type: :feature do
  describe 'as a merchant' do
    before(:each) do
      Merchant.destroy_all
      Customer.destroy_all
      Transaction.destroy_all
      Invoice.destroy_all
      User.destroy_all

      @user = create(:user, role: 0)
      @merchant = create(:merchant, user: @user)

      @user1 = create(:user, role: 0)
      @customer_1 = create(:customer, user: @user1)
      @invoice_1 = create(:invoice, merchant: @merchant, customer: @customer_1)
      @invoice_2 = create(:invoice, merchant: @merchant, customer: @customer_1)
      create(:transaction, result: 1, invoice: @invoice_1)
      create(:transaction, result: 1, invoice: @invoice_2)

      @user2 = create(:user, role: 0)
      @customer_2 = create(:customer, user: @user2)
      @invoice_3 = create(:invoice, merchant: @merchant, customer: @customer_2)
      @invoice_4 = create(:invoice, merchant: @merchant, customer: @customer_2)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_4)

      @user3 = create(:user, role: 0)
      @customer_5 = create(:customer, user: @user3)
      @invoice_5 = create(:invoice, merchant: @merchant, customer: @customer_5)
      @invoice_6 = create(:invoice, merchant: @merchant, customer: @customer_5)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_6)

      @user4 = create(:user, role: 0)
      @customer_4 = create(:customer, user: @user4)
      @invoice_7 = create(:invoice, merchant: @merchant, customer: @customer_4)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)

      @user5 = create(:user, role: 0)
      @customer_3 = create(:customer, user: @user5)
      @invoice_8 = create(:invoice, merchant: @merchant, customer: @customer_3)
      create(:transaction, result: 0, invoice: @invoice_7)

      @user6 = create(:user, role: 0)
      @customer_6 = create(:customer, user: @user6)
      @invoice_9 = create(:invoice, merchant: @merchant, customer: @customer_6, created_at: '2010-03-27 14:53:59', status: :completed)
      @invoice_10 = create(:invoice, merchant: @merchant, customer: @customer_6, created_at: '2010-01-27 14:53:59')
      create(:transaction, result: 1, invoice: @invoice_9)

      create_list(:item, 3, merchant: @merchant)

      5.times do
        create(:invoice_item, item: Item.first, invoice: Invoice.all.sample, status: 2)
      end

      2.times do
        create(:invoice_item, item: Item.second, invoice: @invoice_9, status: 1)
      end
      3.times do
        create(:invoice_item, item: Item.second, invoice: @invoice_7, status: 1)
      end

      5.times do
        create(:invoice_item, item: Item.third, invoice: Invoice.all.sample, status: 0)
      end
      login_as(@user, scope: :user)
    end

    it 'can show an an items name, description, current selling price.' do
      visit merchant_item_path(@merchant.id, @merchant.items.first.id)

      expect(page).to have_content("#{@merchant.items.first.name}")
      expect(page).to have_content("#{@merchant.items.first.description}")
      expect(page).to have_content("#{@merchant.items.first.unit_price}")

    end

  end
end
