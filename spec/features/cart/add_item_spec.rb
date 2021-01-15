require 'rails_helper'

RSpec.describe "When a user adds items to their cart" do
  it "displays a message" do
    @user = create(:user)
    @merchant = create(:merchant, user: @user, status: 1)
    @item = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)

    visit "/"

    within("#item-#{@item.id}") do
      click_button "Add To Cart"
    end

    visit "/"

    within("#item-#{@item2.id}") do
      click_button "Add To Cart"
    end

    visit "/"
    
    within("#item-#{@item.id}") do
      click_button "Add To Cart"
    end

    expect(page).to have_content("You now have 2 copies of #{@item.name} in your cart.")
  end
end
