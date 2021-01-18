require 'rails_helper'

describe 'As an admin' do
  describe 'When i visit an admin invoice show apge' do
    before :each do
      @admin = create(:user, admin: true)
      @user1 = create(:user)
      @user2 = create(:user)

      @merchant = create(:merchant, user: @user1)

      @invoice_1 = create(:invoice, user: @user2, status: 0)

      @item = create(:item, merchant: @merchant)
      @item2 = create(:item, merchant: @merchant)

      @invoice_item = create(:invoice_item, item: @item, invoice: @invoice_1, status: 0)
      @invoice_item2 = create(:invoice_item, item: @item2, invoice: @invoice_1, status: 0)

      login_as(@admin, scope: :user)
    end

    it 'I see the invoices attributes' do
      visit admin_invoice_path(@invoice_1)

      within("#invoice-info") do
        expect(page).to have_content(@invoice_1.date)
        expect(page).to have_content(@invoice_1.total_revenue.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse)
      end
    end

    it 'I see the customer info pertaining to the invoice' do
      visit admin_invoice_path(@invoice_1)

      within("#customer-info") do
        expect(page).to have_content("#{@invoice_1.customer_name}")
        expect(page).to have_content("123 Drury Ln")
        expect(page).to have_content("Nowhere, ID 10001")
      end
    end

    it 'I can update the invoices status' do
      visit admin_invoice_path(@invoice_1)

      within("#update-status") do
        expect(page).to have_content("Cancelled")

        select("Completed", :from => "invoice[status]")

        click_button "Update Invoice"

        expect(page).to have_content("Completed")
      end

      expect(page).to have_content("Invoice successfully updated")
    end

    it 'can see that discounts were applied' do
      item4 = create(:item, unit_price: 20, merchant: @merchant)
      item5 = create(:item, unit_price: 30, merchant: @merchant)
      data = {"#{item4.id}" => 5, "#{item5.id}" => 1}
      discount = create(:discount, merchant: @merchant, minimum: 3, percentage: 50)
      order = Order.new(data, @user1)
      order.create_invoice
      order.invoice_items
      invoice = Invoice.find(order.invoice.id)
      visit admin_invoice_path(invoice)

      expect(page).to have_content("Total Revenue: $#{invoice.total_revenue}")
      expect(page).to have_content("Discounts Applied: #{discount.name}")
    end
  end
end
