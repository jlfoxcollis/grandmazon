require 'rails_helper'

describe 'As an admin' do
  describe 'When i visit the admin invoices index' do
    before :each do
	    @admin = create(:user, role: 1)
      @user1 = create(:user, role: 0)
      @user2 = create(:user, role: 0)

      @merchant = create(:merchant, user: @user1)

      @customer_1 = create(:customer, user: @user2)

      @invoice_1 = create(:invoice, customer: @customer_1, merchant: @merchant)
      @invoice_2 = create(:invoice, customer: @customer_1, merchant: @merchant)
      @invoice_3 = create(:invoice, customer: @customer_1, merchant: @merchant)

      login_as(@admin, scope: :user)
    end

    it 'I see the links to each invoice' do
      visit admin_invoices_path

      within("#invoices") do
        expect(page).to have_content(@invoice_1.id)
        expect(page).to have_content(@invoice_2.id)
        expect(page).to have_content(@invoice_3.id)

        click_on "#{@invoice_1.id}"
        expect(current_path).to eq(admin_invoice_path(@invoice_1))
      end
    end
  end
end
