require 'rails_helper'

RSpec.describe 'merchant discounts index', type: :feature do
  before :each do
    @user = create(:user)
    @user2 = create(:user)

    @merchant = create(:merchant, user: @user)
    @item1 = create(:item, merchant: @merchant)
    @discount = create(:discount, percentage: 50, minimum: 1, merchant: @merchant)
    @discount1 = create(:discount, merchant: @merchant)
    @invoice = create(:invoice, user: @user2, status: 1)
    @invoice_item = create(:invoice_item, user: @user2, item: @item1, quantity: 10, discount_id: @discount.id)

    login_as(@user, scope: :user)
  end

  describe 'As a merchant' do
    it 'can see all discounts' do
      visit merchant_dashboard_index_path(@merchant)

      click_on "Discounts"

      within("#discount-#{@discount1.id}") do
        click_link "#{@discount1.name}"
      end
      expect(page).to have_content("#{@discount1.name}")

      click_on "Edit Discount"

        have_selector("input", :type => "text",
                        :name => "discount[name]",
                        :value => "#{@discount1.name}")

      fill_in "discount[name]", with: "super sale"

      click_on "Update Discount"

      expect(current_path).to eq(merchant_discount_path(@merchant, @discount1))
      expect(page).to have_content("super sale")
    end

    it 'can fail to update' do
      visit merchant_dashboard_index_path(@merchant)

      click_on "Discounts"

      within("#discount-#{@discount1.id}") do
        click_link "#{@discount1.name}"
      end

      click_on "Edit Discount"
      fill_in "discount[name]", with: ""

      click_on "Update Discount"


      expect(page).to have_content("Name can't be blank")
    end

    it 'can fail to update due to pending invoice_items' do
      @invoice1 = create(:invoice, user: @user2, status: 1)
      @invoice_item3 = create(:invoice_item, user: @user2, status: 0, item: @item1, quantity: 10, discount_id: @discount.id)

      visit merchant_dashboard_index_path(@merchant)

      click_on "Discounts"

      within("#discount-#{@discount.id}") do
        click_link "#{@discount.name}"
      end

      click_on "Edit Discount"
      fill_in "discount[name]", with: "changing the discount"

      click_on "Update Discount"


      expect(page).to have_content("Can't update discount with pending invoices.")
    end

  end
end
