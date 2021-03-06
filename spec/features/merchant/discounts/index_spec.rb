require 'rails_helper'

RSpec.describe 'merchant discounts index', type: :feature do
  before :each do
    @user = create(:user)
    @merchant = create(:merchant, user: @user)
    @discount = create(:discount, merchant: @merchant)
    @discount1 = create(:discount, merchant: @merchant)

    @invoice_1 = create(:invoice, user: @user)
    @invoice_2 = create(:invoice, user: @user)
    create(:transaction, result: 1, invoice: @invoice_1)
    create(:transaction, result: 1, invoice: @invoice_2)

    create_list(:item, 3, merchant: @merchant)
    2.times do
      create(:invoice_item, item: Item.first, invoice: @invoice_1)
      create(:invoice_item, item: Item.second, invoice: @invoice_1)
      create(:invoice_item, item: Item.third, invoice: @invoice_1)
      create(:invoice_item, item: Item.first, invoice: @invoice_2)
    end

    login_as(@user, scope: :user)
  end

  describe 'As a merchant' do
    it 'can see all discounts' do
      visit merchant_dashboard_index_path(@merchant)

      click_on "Discounts"

      within("#discount-#{@discount.id}") do
        expect(page).to have_link("#{@discount.name}")
        expect(page).to have_content("Minimum Quantity: #{@discount.minimum}")
        expect(page).to have_content("Percent off: #{@discount.percentage}")
      end

      expect(page).to have_link("Create Discount")
    end
  end
end
