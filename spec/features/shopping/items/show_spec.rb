require 'rails_helper'

describe 'it can show an items show page', type: :feature do
  it 'displays an item for sale' do
    @user = create(:user)
    @merchant = create(:merchant, user: @user)
    @item = create(:item, merchant: @merchant)

    visit shopping_merchant_item_path(@merchant, @item)

    expect(page).to have_content("#{@item.name}")
    expect(page).to have_content("Current Price: $#{@item.unit_price}.00")
    expect(page).to have_content("Discounts Available:")
  end
end
