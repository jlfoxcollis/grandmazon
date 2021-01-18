require 'rails_helper'

RSpec.describe 'it can see all orders it placed', type: :feature do

  it 'it can view the orders index' do
      @user = create(:user)
      @merchant = create(:merchant, user: @user)
      @discount = create(:discount, merchant: @merchant)
      @discount1 = create(:discount, merchant: @merchant)

      @invoice_1 = create(:invoice, user: @user)
      @invoice_2 = create(:invoice, user: @user)
      create(:transaction, result: 1, invoice: @invoice_1)
      create(:transaction, result: 1, invoice: @invoice_2)

      create_list(:item, 3, merchant: @merchant)
      2.times do
        create(:invoice_item, item: Item.first, invoice: @invoice_1)
        create(:invoice_item, item: Item.second, invoice: @invoice_1)
        create(:invoice_item, item: Item.third, invoice: @invoice_1)
        create(:invoice_item, item: Item.first, invoice: @invoice_2)
      end

      login_as(@user, scope: :user)

      visit user_orders_path(@user)
      within("#order-#{@invoice_1.id}") do
        expect(page).to have_content("Item count on invoice: #{@invoice_1.items.count}")
      end
    end
  end
