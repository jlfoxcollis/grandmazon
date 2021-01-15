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
        expect(page).to have_link("#{@discount.name}")
        expect(page).to have_content("Minimum Quantity: #{@discount.minimum}")
        expect(page).to have_content("Percent off: #{@discount.percentage}")

        click_on("Delete Discount")
      end
      expect(page).to_not have_content(@discount.name)
    end
  end
end
