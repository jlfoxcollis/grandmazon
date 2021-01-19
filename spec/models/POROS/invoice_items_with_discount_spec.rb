require 'rails_helper'

describe InvoiceItemsWithDiscount do
  it 'can update an invoices invoice_items with discount percentages' do
    @user = create(:user)
    @user2 = create(:user)
    @merchant = create(:merchant, user: @user2)
    item4 = create(:item, unit_price: 20, merchant: @merchant)
    item5 = create(:item, unit_price: 30, merchant: @merchant)
    data = {"#{item4.id}" => 5, "#{item5.id}" => 5}
    discount = create(:discount, merchant: @merchant, minimum: 3, percentage: 50)
    order = Order.new(data, @user)
    order.create_invoice
    order.invoice_items
    invoice = Invoice.find(order.invoice.id)
    expect(invoice.invoice_items.first.discount_percent).to eq(nil)
    invitemswithdiscount = InvoiceItemsWithDiscount.update_percentage(invoice.invoice_items)
    expect(invoice.invoice_items.first.discount_percent).to eq(discount.percentage)

  end

end
