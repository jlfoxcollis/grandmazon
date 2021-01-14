class Order

  def initialize(data, customer)
    @customer = customer
    @contents = data
    invoice_items
  end

  def count_of(id)
    @contents[id.to_s].to_i
  end

  def item_list
    Item.where(id: @contents.keys)
  end

  def invoice
      Invoice.create(customer: @customer, status: 1)
    end.uniq
  end

  def invoice_items
    item_list.map do |item|
      InvoiceItem.create(quantity: count_of(item.id), unit_price: item.unit_price, status: 0, item: item, invoice: invoice)
    end
  end
end
