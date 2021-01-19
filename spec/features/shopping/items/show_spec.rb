require 'rails_helper'

describe 'it can show an items show page', type: :feature do
  it 'displays an item for sale' do
    @merchant = create(:merchant)
    @item = create(:item, merchant: @merchant)

    visit shopping_item_path(@item)

    expect(page).to have_content("For Sale: #{@item.name}")
    expect(page).to have_content("Price: #{@item.unit_price}")
    expect(page).to have_content("Available Discounts:")
  end
end
