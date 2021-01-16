require 'rails_helper'

RSpec.describe 'merchant discounts index', type: :feature do
  before :each do
    @user = create(:user)
    @merchant = create(:merchant, user: @user)
    @discount = create(:discount, merchant: @merchant)
    @discount1 = create(:discount, merchant: @merchant)

    login_as(@user, scope: :user)
  end

  describe 'As a merchant' do
    it 'can see all discounts' do
      visit merchant_dashboard_index_path(@merchant)

      click_on "Discounts"

      within("#discount-#{@discount.id}") do
        click_link "#{@discount.name}"
      end
      expect(page).to have_content("#{@discount.name}")

      click_on "Edit Discount"

        have_selector("input", :type => "text",
                        :name => "discount[name]",
                        :value => "#{@discount.name}")

      fill_in "discount[name]", with: "super sale"

      click_on "Update Discount"

      expect(current_path).to eq(merchant_discount_path(@merchant, @discount))
      save_and_open_page
      expect(page).to have_content("super sale")
    end

    it 'can fail to update' do
      visit merchant_dashboard_index_path(@merchant)

      click_on "Discounts"

      within("#discount-#{@discount.id}") do
        click_link "#{@discount.name}"
      end

      click_on "Edit Discount"
      fill_in "discount[name]", with: ""

      click_on "Update Discount"


      expect(page).to have_content("Name can't be blank")
    end

  end
end
