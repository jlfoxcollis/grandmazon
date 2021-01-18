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
      @invoice_1 = create(:invoice,  user: @user1)
      @invoice_2 = create(:invoice,  user: @user1)
      create(:transaction, result: 1, invoice: @invoice_1)
      create(:transaction, result: 1, invoice: @invoice_2)

      @user2 = create(:user)
      @invoice_3 = create(:invoice,  user: @user2)
      @invoice_4 = create(:invoice,  user: @user2)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_4)

      @user3 = create(:user)
      @invoice_5 = create(:invoice,  user: @user3)
      @invoice_6 = create(:invoice,  user: @user3)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_6)

      @user4 = create(:user)
      @invoice_7 = create(:invoice, status: 0, user: @user4)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)

      @user5 = create(:user)
      @invoice_8 = create(:invoice,  user: @user5)
      create(:transaction, result: 0, invoice: @invoice_7)

      @user6 = create(:user)
      @invoice_9 = create(:invoice,  user: @user6, created_at: '2010-03-27 14:53:59', status: :completed)
      @invoice_10 = create(:invoice,  user: @user6, created_at: '2010-01-27 14:53:59')
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

    it 'can show all that merchants invoice attributes' do
      visit merchant_invoice_path(@merchant.id, @invoice_9.id)

      expect(page).to have_content(@invoice_9.id)
      expect(page).to have_content("Status: Completed")
      expect(page).to have_content(@invoice_9.date)
    end

    it 'can show customer info for invoice' do
      visit merchant_invoice_path(@merchant.id, @invoice_9.id)

      expect(page).to have_content(@invoice_9.customer_name)
    end

    it 'can show my items on the invoice' do
      visit merchant_invoice_path(@merchant.id, @invoice_9.id)
      invoice_item = @invoice_9.invoice_items.first
      expect(page).to have_content("#{invoice_item.item.name}")
      expect(page).to have_content("#{invoice_item.quantity}")
      expect(page).to have_content("#{invoice_item.unit_price}")
    end

    it 'can show total revenue for that invoice' do
      visit merchant_invoice_path(@merchant.id, @invoice_9.id)
      expect(page).to have_content("Total Revenue: $#{@invoice_9.total_revenue.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}")
    end

    it 'can enable/disable status of item' do
      visit merchant_invoice_path(@merchant, @invoice_7)
      within("#status-#{@invoice_7.invoice_items.first.id}") do
        select("Pending", from: "invoice_item[status]")
        click_button "Submit"

        expect(@invoice_7.invoice_items.first.status).to eq("pending")
      end
    end

    it 'can show if a discount was applied' do
      item4 = create(:item, unit_price: 20, merchant: @merchant)
      item5 = create(:item, unit_price: 30, merchant: @merchant)
      data = {"#{item4.id}" => 5, "#{item5.id}" => 1}
      discount = create(:discount, merchant: @merchant, minimum: 3, percentage: 50)
      order = Order.new(data, @user1)
      order.create_invoice
      order.invoice_items
      invoice = Invoice.find(order.invoice.id)
      visit merchant_invoice_path(@merchant, order.invoice)
      no_discount = ((item4.unit_price * 5) + (item5.unit_price * 1))
      discounted = ((item4.unit_price * 5 * 50 / 100.0) + (item5.unit_price * 1))
      expect(no_discount).to_not eq(discounted)
      expect(order.invoice.total_revenue).to_not eq(no_discount)
      expect(order.invoice.total_revenue).to eq(discounted)

      expect(page).to have_content("Total Revenue: $#{order.invoice.total_revenue}")
    end

    it 'has a link to view any discount that applied' do
      item4 = create(:item, unit_price: 20, merchant: @merchant)
      item5 = create(:item, unit_price: 30, merchant: @merchant)
      data = {"#{item4.id}" => 5, "#{item5.id}" => 1}
      discount = create(:discount, merchant: @merchant, minimum: 3, percentage: 50)
      order = Order.new(data, @user1)
      visit merchant_invoice_path(@merchant, order.invoice)

      expect(page).to have_link("#{discount.name}")

    end

  end
end
