require 'rails_helper'

describe 'As an Admin' do
  describe 'When i visit the admin dashboard' do
    before :each do
	    @admin = create(:user, role: 1)

      @user1 = create(:user, role: 1)
      @user2 = create(:user, role: 0)
      @user3 = create(:user, role: 0)
      @user4 = create(:user, role: 0)
      @user5 = create(:user, role: 0)
      @user6 = create(:user, role: 0)
      @user7 = create(:user, role: 0)

      @merchant = create(:merchant, user: @user1)

      @customer_1 = create(:customer, user: @user2)
      @customer_2 = create(:customer, user: @user3)
      @customer_3 = create(:customer, user: @user4)
      @customer_4 = create(:customer, user: @user5)
      @customer_5 = create(:customer, user: @user6)
      @customer_6 = create(:customer, user: @user7)

      Customer.all.each do |customer|
        create_list(:invoice, 1, customer: customer, merchant: @merchant)
      end

      customer_list = [@customer_1, @customer_2, @customer_3, @customer_4, @customer_5, @customer_6]

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
        expect(all('#customer')[0].text).to eq("#{@customer_6.name} - #{@customer_6.successful_purchases} Purchases")
        expect(all('#customer')[1].text).to eq("#{@customer_5.name} - #{@customer_5.successful_purchases} Purchases")
        expect(all('#customer')[2].text).to eq("#{@customer_4.name} - #{@customer_4.successful_purchases} Purchases")
        expect(all('#customer')[3].text).to eq("#{@customer_3.name} - #{@customer_3.successful_purchases} Purchases")
        expect(all('#customer')[4].text).to eq("#{@customer_2.name} - #{@customer_2.successful_purchases} Purchases")
      end
    end

    it 'I see all incomplete invoices sorted by least recent' do
      @invoice_1 = create(:invoice, customer: @customer_1, merchant: @merchant, status: 0, created_at: "2006-01-25 09:54:09")
      @invoice_2 = create(:invoice, customer: @customer_1, merchant: @merchant, status: 1, created_at: "2007-02-25 09:54:09")
      @invoice_3 = create(:invoice, customer: @customer_1, merchant: @merchant, status: 0, created_at: "2008-03-25 09:54:09")
      @invoice_4 = create(:invoice, customer: @customer_1, merchant: @merchant, status: 0, created_at: "2009-04-25 09:54:09")

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
      @user = create(:user, role: 0)
      @merchant = create(:merchant, user: @user)
      login_as(@user)
      visit admin_index_path
      expect(current_path).to eq("/")
    end
  end
end
