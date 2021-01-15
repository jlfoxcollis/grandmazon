require 'rails_helper'

RSpec.describe Order do
  before :each do
    @user = create(:user, role: 0)
    @customer = create(:customer, user: @user)
    @user2 = create(:user, role: 1)
    @merchant = create(:merchant, user: @user2)
    @item = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)
    @user2 = create(:user, role: 0)
  end

  subject { Cart.new({ "#{@item.id}" => 2, "#{@item2.id}" => 3 }) }

  it 'can create invoices' do
    order = Order.new(subject.contents, @customer)
    expect(order.count_of(@item.id)).to eq(2)
  end

  it 'can return invoices & invoice_items' do
    order = Order.new(subject.contents, @customer)
    expect(order.invoices.count).to eq(1)
    expect(order.invoice_items.count).to eq(2)
    expect(order.invoices.first.customer_id).to eq(@customer.id)
  end
end
