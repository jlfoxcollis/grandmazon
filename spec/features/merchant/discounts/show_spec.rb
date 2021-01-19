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
      expect(page).to have_content("#{@discount.minimum}")
      expect(page).to have_content("#{@discount.percentage}")
    end
  end
end
