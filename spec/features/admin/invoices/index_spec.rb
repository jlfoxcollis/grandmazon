require 'rails_helper'

describe 'As an admin', type: :feature do
  describe 'When i visit the admin invoices index' do
    before :each do
	    @admin = create(:user)
      @user1 = create(:user)
      @user2 = create(:user)

      @merchant = create(:merchant, user: @user1)


      @invoice_1 = create(:invoice, status: 1, user: @user2)
      @invoice_2 = create(:invoice, user: @user2)
      @invoice_3 = create(:invoice, user: @user2)

      login_as(@admin, scope: :user)
    end

    it 'I see the links to each invoice' do
      visit admin_invoices_path

      within("#invoice-#{@invoice_1.id}") do
        expect(page).to have_content(@invoice_1.id)

        click_on "#{@invoice_1.id}"
        expect(current_path).to eq(admin_invoice_path(@invoice_1))
      end
    end
  end
end
