require 'rails_helper'

describe 'can see all discounts applied to an invoice', type: :feature do
  describe 'when i visit the merchant invoice discounts index' do
    it 'can show all discounts applied' do
      @user = create(:user)
      @merchant = create(:merchant, user: @user)
      @discount = create(:discount, minimum: 2, percentage: 20.00, merchant: @merchant)
      @discount1 = create(:discount, minimum: 6, percentage: 30.00, merchant: @merchant)

      @invoice_1 = create(:invoice, user: @user)
      @invoice_2 = create(:invoice, user: @user)
      create(:transaction, result: 1, invoice: @invoice_1)
      create(:transaction, result: 1, invoice: @invoice_2)

      create_list(:item, 3, merchant: @merchant)
      2.times do
        create(:invoice_item, quantity: 4, item: Item.first, invoice: @invoice_1, discount_id: @discount.id)
        create(:invoice_item, quantity: 2, item: Item.second, invoice: @invoice_1)
        create(:invoice_item, quantity: 7, item: Item.third, invoice: @invoice_1, discount_id: @discount1.id)
        create(:invoice_item, quantity: 2, item: Item.first, invoice: @invoice_2)
      end

      login_as(@user)

      visit merchant_invoice_path(@merchant, @invoice_1)

      click_on "Applied Discounts"

      within("#discount-#{@discount.id}") do
        expect(page).to have_content(@discount.name)
        expect(page).to have_content(@discount.percentage)
        expect(page).to have_content(@discount.minimum)
      end

      within("#discount-#{@discount1.id}") do
        expect(page).to have_content(@discount1.name)
        expect(page).to have_content(@discount1.percentage)
        expect(page).to have_content(@discount1.minimum)
      end
    end
  end
end
