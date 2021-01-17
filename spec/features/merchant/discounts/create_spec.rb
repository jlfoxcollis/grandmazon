require 'rails_helper'

RSpec.describe 'merchant discounts create', type: :feature do
  before :each do
    @user = create(:user)
    @merchant = create(:merchant, user: @user)
    @discount = create(:discount, merchant: @merchant)
    @discount1 = create(:discount, merchant: @merchant)
    login_as(@user, scope: :user)
  end

  describe 'As a merchant' do
    it 'can see all discounts' do
      visit merchant_discounts_path(@merchant)

      click_on "Create Discount"

      fill_in "name", with: "Big Summer Blowout!"
      fill_in "percentage", with: 30
      fill_in "minimum", with: 2

      click_on "Create Discount"
      expect(current_path).to eq(merchant_discounts_path(@merchant))
      expect(page).to have_content("Discount created Successfully!")

      within("#discount-#{Discount.last.id}") do
        expect(page).to have_content("#{Discount.last.name}")
        expect(page).to have_content("#{Discount.last.percentage}")
      end
    end
  end
end
