require 'rails_helper'

RSpec.describe 'it can see all orders it placed', type: :feature do

  it 'it can view the orders index' do
      @user = create(:user)
      @merchant = create(:merchant, user: @user)
      @discount = create(:discount, merchant: @merchant)
      @discount1 = create(:discount, merchant: @merchant)
      @item = create(:item, merchant: @merchant)
      @item2 = create(:item, merchant: @merchant)

      @invoice_1 = create(:invoice, status: 1, user: @user)
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
      subject = Cart.new({ "#{@item.id}" => 2, "#{@item2.id}" => 3 })
      order = Order.new(subject.contents, @user)
      expect(order.count_of(@item.id)).to eq(2)
      login_as(@user, scope: :user)

      visit user_orders_path(@user)

      within("#order-#{@invoice_1.id}") do
        expect(page).to have_content("Item count on invoice: #{@invoice_1.items.count}")
      end

    end
  end
