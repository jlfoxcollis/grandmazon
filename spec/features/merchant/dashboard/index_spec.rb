require 'rails_helper'

RSpec.describe 'merchant dashboard index', type: :feature do
  describe 'as a merchant' do
    before(:each) do
      Merchant.destroy_all
      Transaction.destroy_all
      Invoice.destroy_all
      User.destroy_all

      @user = create(:user)
      @merchant = create(:merchant, user: @user)

      @user2 = create(:user)
      @invoice_1 = create(:invoice, user: @user2)
      @invoice_2 = create(:invoice, user: @user2)
      create(:transaction, result: 1, invoice: @invoice_1)
      create(:transaction, result: 1, invoice: @invoice_2)

      @user3 = create(:user)
      @invoice_3 = create(:invoice, user: @user3)
      @invoice_4 = create(:invoice, user: @user3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_4)

      @user4 = create(:user)
      @invoice_5 = create(:invoice, user: @user4)
      @invoice_6 = create(:invoice, user: @user4)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_6)

      @user5 = create(:user)
      @invoice_7 = create(:invoice, user: @user5)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)

      @user6 = create(:user)
      @invoice_8 = create(:invoice, user: @user6)
      create(:transaction, result: 0, invoice: @invoice_7)

      @user7 = create(:user)
      @invoice_9 = create(:invoice, user: @user7, created_at: '2010-03-27 14:53:59')
      @invoice_10 = create(:invoice, user: @user7, created_at: '2010-01-27 14:53:59')
      create(:transaction, result: 1, invoice: @invoice_9)

      create_list(:item, 3, merchant: @merchant)

      5.times do
        create(:invoice_item, item: Item.first, invoice: @invoice_9, status: 1)
        create(:invoice_item, item: Item.second, invoice: @invoice_8, status: 1)
        create(:invoice_item, item: Item.first, invoice: @invoice_7, status: 2)
        create(:invoice_item, item: Item.first, invoice: @invoice_6, status: 2)
        create(:invoice_item, item: Item.first, invoice: @invoice_5, status: 2)
        create(:invoice_item, item: Item.first, invoice: @invoice_4, status: 2)
        create(:invoice_item, item: Item.first, invoice: @invoice_3, status: 2)
        create(:invoice_item, item: Item.first, invoice: @invoice_2, status: 2)
        create(:invoice_item, item: Item.first, invoice: @invoice_1, status: 2)
      end

      login_as(@user, scope: :user)
    end

    it 'When I visit my merchant dashboard then I see the name of my merchant' do
      visit merchant_dashboard_index_path(@merchant)
      expect(page).to have_content(@merchant.name)
    end

    it 'When I visit my merchant dashboard Then I see link to my merchant items index (/merchant/merchant_id/items) And I see a link to my merchant invoices index (/merchant/merchant_id/invoices)' do
      visit merchant_dashboard_index_path(@merchant)
      expect(page).to have_link('My Items')
      expect(page).to have_link('My Invoices')
    end

    it 'can show top 5 customers of the merchant' do
      visit merchant_dashboard_index_path(@merchant)

      expect(page).to have_content("#{@user5.first_name} #{@user5.last_name} - #{@merchant.top_5[0].total_success} purchases")
      expect(page).to have_content("#{@user3.first_name} #{@user3.last_name} - #{@merchant.top_5[1].total_success} purchases")
      expect(page).to have_content("#{@user4.first_name} #{@user4.last_name} - #{@merchant.top_5[2].total_success} purchases")
      expect(page).to have_content("#{@user2.first_name} #{@user2.last_name} - #{@merchant.top_5[3].total_success} purchases")
      expect(page).to have_content("#{@user7.first_name} #{@user7.last_name} - #{@merchant.top_5[4].total_success} purchase")

      expect(@user5.name).to appear_before(@user3.name)
      expect(@user2.name).to appear_before(@user7.name)
    end

    it 'can show all items not yet shipped, and show items invoice id as a link.' do
      visit merchant_dashboard_index_path(@merchant)

      expect(page).to have_content(Item.second.name)

      expect(page).to have_link("#{@invoice_9.id}")
    end

    it 'can show date and is in desc order' do
      visit merchant_dashboard_index_path(@merchant)

      expect(page).to have_content(Item.first.created_at.strftime('%A, %b %d %Y'))
      # expect(@invoice_9.id).to appear_before(@invoice_10.id)
      # expect(@invoice_10.id).to appear_before(@invoice_8.id)
    end
  end
end
