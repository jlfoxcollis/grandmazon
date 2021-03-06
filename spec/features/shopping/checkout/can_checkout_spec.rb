require 'rails_helper'

RSpec.describe "When a user tries to checkout", type: :feature do
  it "displays a message" do
    @user = create(:user)
    @merchant = create(:merchant, user: @user, status: 1)
    @item = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)
    @user1 = create(:user)

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

    visit "/"

    click_on "Cart (3)"

    within("#item-#{@item.id}") do
      click_on "Remove Item"
    end

      click_on 'Check Out'

    expect(page).to have_content("Login")

    fill_in "user[email]", with: "#{@user1.email}"
    fill_in "user[password]", with: "#{@user1.password}"

    click_button "Log in"

    click_on "Cart (1)"

    click_on 'Check Out'

    click_on 'Submit Order'

    expect(page).to have_content("Invoice-#{@user1.invoices.first.id}")
  end
end
