require 'rails_helper'

RSpec.describe Order do
  before :each do
    @user = create(:user)
    @user2 = create(:user)
    @merchant = create(:merchant, user: @user2)
    @item = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)
  end

  subject { Cart.new({ "#{@item.id}" => 2, "#{@item2.id}" => 3 }) }

  it 'can create invoices' do
    order = Order.new(subject.contents, @user)
    expect(order.count_of(@item.id)).to eq(2)
  end

  it 'can return invoices & invoice_items' do
    order = Order.new(subject.contents, @user)
    expect(order.invoice).to eq(Invoice.last)
    expect(order.invoice_items.count).to eq(2)
    expect(order.invoice.user_id).to eq(@user.id)
  end

  it 'can add discounts to items' do
    item4 = create(:item, unit_price: 20, merchant: @merchant)
    item5 = create(:item, unit_price: 30, merchant: @merchant)
    data = {"#{item4.id}" => 5, "#{item5.id}" => 1}
    discount = create(:discount, merchant: @merchant, minimum: 3, percentage: 50)
    order = Order.new(data, @user)
    order.create_invoice
    order.invoice_items
    invoice = Invoice.find(order.invoice.id)
    no_discount = ((item4.unit_price * 5) + (item5.unit_price * 1))
    discounted = ((item4.unit_price * 5 * 50 / 100.0) + (item5.unit_price * 1))
    expect(no_discount).to_not eq(discounted)
    expect(order.invoice.total_revenue).to_not eq(no_discount)
    expect(order.invoice.total_revenue).to eq(discounted)
  end
end
