require 'rails_helper'

RSpec.describe 'merchants invoices index page', type: :feature do
  describe 'as a merchant' do
    before(:each) do
      Merchant.destroy_all
      Transaction.destroy_all
      Invoice.destroy_all
      User.destroy_all

      @user = create(:user)
      @merchant = create(:merchant, user: @user)

      @user1 = create(:user)
      @invoice_1 = create(:invoice, user: @user1)
      @invoice_2 = create(:invoice, user: @user1)
      create(:transaction, result: 1, invoice: @invoice_1)
      create(:transaction, result: 1, invoice: @invoice_2)

      @user2 = create(:user)
      @invoice_3 = create(:invoice, user: @user2)
      @invoice_4 = create(:invoice, user: @user2)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_4)

      @user3 = create(:user)
      @invoice_5 = create(:invoice, user: @user3)
      @invoice_6 = create(:invoice, user: @user3)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_6)

      @user4 = create(:user)
      @invoice_7 = create(:invoice, user: @user4)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)

      @user5 = create(:user)
      @invoice_8 = create(:invoice, user: @user3)
      create(:transaction, result: 0, invoice: @invoice_7)

      @user6 = create(:user)
      @invoice_9 = create(:invoice, user: @user6, created_at: '2010-03-27 14:53:59')
      @invoice_10 = create(:invoice, user: @user6, created_at: '2010-01-27 14:53:59')
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

    it 'can show all that merchants invoices, with a link to merchants invoice show page' do
      visit merchant_invoices_path(@merchant.id)
      expect(page).to have_content(@invoice_9.id)
      expect(page).to have_link("#{@invoice_9.id}")
    end
  end
end
