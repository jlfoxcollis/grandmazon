# require 'rails_helper'
#
# RSpec.describe Order do
#   before :each do
#     @user = create(:user)
#     @user2 = create(:user)
#     @merchant = create(:merchant, user: @user2)
#     @item = create(:item, merchant: @merchant)
#     @item2 = create(:item, merchant: @merchant)
#   end
#
#   subject { Cart.new({ "#{@item.id}" => 2, "#{@item2.id}" => 3 }) }
#
#   xit 'can create invoices' do
#     order = Order.new(subject.contents, @user)
#     expect(order.count_of(@item.id)).to eq(2)
#   end
#
#   xit 'can return invoices & invoice_items' do
#     order = Order.new(subject.contents, @user)
#     expect(order.invoices.count).to eq(1)
#     expect(order.invoice_items.count).to eq(2)
#     expect(order.invoices.first).to eq(@user.id)
#   end
# end
