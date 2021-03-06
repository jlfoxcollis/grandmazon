require 'rails_helper'

describe 'As an Admin', type: :feature do
  describe 'When i visit the admin dashboard' do
    before :each do
	    @admin = create(:user)

      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      @user4 = create(:user)
      @user5 = create(:user)
      @user6 = create(:user)
      @user7 = create(:user)

      @merchant = create(:merchant, user: @user1)

      User.all.each do |user|
        create_list(:invoice, 1, user: user)
      end

      customer_list = [@user2, @user3, @user4, @user5, @user6, @user7]

      customer_list.size.times do |i|
        create_list(:transaction, (i+1), invoice: customer_list[i].invoices.first, result: 1)
      end

      login_as(@admin, scope: :user)
    end

    it 'I the admins dashboard with nav links' do
      visit admin_index_path
      expect(page).to have_content('Admin Dashboard')
      expect(page).to have_link("Merchants")
      expect(page).to have_link("Invoices")
    end

    it 'I can see the top customers' do
      visit admin_index_path


      within('#top-customers') do
        expect(page).to have_content("Top 5 Customers")
        expect(all('#customer')[0].text).to eq("#{@user7.name} - #{@user7.successful_purchases} Purchases")
        expect(all('#customer')[1].text).to eq("#{@user6.name} - #{@user6.successful_purchases} Purchases")
        expect(all('#customer')[2].text).to eq("#{@user5.name} - #{@user5.successful_purchases} Purchases")
        expect(all('#customer')[3].text).to eq("#{@user4.name} - #{@user4.successful_purchases} Purchases")
        expect(all('#customer')[4].text).to eq("#{@user3.name} - #{@user3.successful_purchases} Purchases")
      end
    end

    it 'I see all incomplete invoices sorted by least recent' do
      @invoice_1 = create(:invoice, user: @user2, status: 0, created_at: "2006-01-25 09:54:09")
      @invoice_2 = create(:invoice, user: @user2, status: 1, created_at: "2007-02-25 09:54:09")
      @invoice_3 = create(:invoice, user: @user2, status: 0, created_at: "2008-03-25 09:54:09")
      @invoice_4 = create(:invoice, user: @user2, status: 0, created_at: "2009-04-25 09:54:09")

      @item_1 = create(:item, merchant: @merchant)
      @item_2 = create(:item, merchant: @merchant)

      @invoice_item_1 = create(:invoice_item, status: 0, item: @item_1, invoice: @invoice_1)
      @invoice_item_2 = create(:invoice_item, status: 0, item: @item_2, invoice: @invoice_2)
      @invoice_item_3 = create(:invoice_item, status: 1, item: @item_2, invoice: @invoice_3)
      @invoice_item_4 = create(:invoice_item, status: 1, item: @item_1, invoice: @invoice_4)

      visit admin_index_path

      within("#incomplete-invoices") do
        expect(page).to have_content("Incomplete Invoices")

        expect(all('#invoice')[0].text).to eq("Invoice ##{@invoice_1.id} - #{@invoice_1.date}")
        expect(all('#invoice')[1].text).to eq("Invoice ##{@invoice_2.id} - #{@invoice_2.date}")
        expect(all('#invoice')[2].text).to eq("Invoice ##{@invoice_3.id} - #{@invoice_3.date}")
        expect(all('#invoice')[3].text).to eq("Invoice ##{@invoice_4.id} - #{@invoice_4.date}")

        expect(page).to have_link("Invoice ##{@invoice_1.id} - #{@invoice_1.date}")
        expect(page).to have_link("Invoice ##{@invoice_2.id} - #{@invoice_2.date}")
        expect(page).to have_link("Invoice ##{@invoice_3.id} - #{@invoice_3.date}")
        expect(page).to have_link("Invoice ##{@invoice_4.id} - #{@invoice_4.date}")
      end
    end
  end

  describe 'cant view admin dashboard as a merchant' do
    it 'cant do it' do
      @user = create(:user, admin: false)
      login_as(@user)
      visit admin_index_path
      expect(page).to have_content("ACCESS DENIED")
      @user.update({admin: true})
      visit admin_index_path
      expect(current_path).to eq("/admin")
    end
  end
end
