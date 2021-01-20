require 'rails_helper'

RSpec.describe 'Admin Merchants Show', type: :feature do
  before :each do
    @admin = create(:user, admin: true)
    @user1 = create(:user)
    @user2 = create(:user)

    @merchant_1 = create(:merchant, user: @user1)
    @merchant_2 = create(:merchant, user: @user2)
    login_as(@admin, scope: :user)
  end
  describe 'Admin Merchant Show Page' do
    it 'can show a Merchant name' do
      visit admin_merchant_path(@merchant_1)

      expect(page).to have_content(@merchant_1.name)
    end
    it 'can have an update link to change merchant information' do
      visit admin_merchant_path(@merchant_1)
      click_on "Edit Merchant's Info"

      expect(current_path).to eq(edit_admin_merchant_path(@merchant_1))
    end
  end
end
