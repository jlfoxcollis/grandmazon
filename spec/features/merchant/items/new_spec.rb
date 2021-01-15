require 'rails_helper'

RSpec.describe 'merchants can update items', type: :feature do
  before :each do
	  @user = create(:user)
    @merchant = create(:merchant, user: @user)
	  login_as(@user, scope: :user)
  end
  describe 'as a merchant' do
    it 'can fill out a new item form and create an item' do
      visit new_merchant_item_path(@merchant)
      fill_in 'item[name]', with: "fruit"
      fill_in 'item[description]', with: "not a real fruit"
      fill_in 'item[unit_price]', with: 42

      click_button "Create Item"

      expect(current_path).to eq(merchant_items_path(@merchant))
      expect(page).to have_content("Item fruit was created successfully!")
    end
    it 'can fill out invalid attributes and see error messages' do
      name_error = "Name can't be blank"
      description_error = "Description can't be blank"
      price_presence_error = "Unit price can't be blank"
      price_type_error = "Unit price is not a number"

      visit new_merchant_item_path(@merchant)

      click_button "Create Item"

      expect(current_path).to eq(merchant_items_path(@merchant))

      expect(page).to have_content(name_error)
      expect(page).to have_content(description_error)
      expect(page).to have_content(price_presence_error)
      expect(page).to have_content(price_type_error)

      fill_in 'item[description]', with: "not a real fruit"
      fill_in 'item[unit_price]', with: 'helo'

      click_button "Create Item"

      expect(page).to have_content(name_error)
      expect(page).to have_content(price_type_error)

      fill_in 'item[name]', with: "fruit"
      fill_in 'item[description]', with: "not a real fruit"
      fill_in 'item[unit_price]', with: 42

      click_button "Create Item"

      expect(current_path).to eq(merchant_items_path(@merchant))
      expect(page).to have_content("Item fruit was created successfully!")
    end
  end
end
