class Order

  def initialize(data, user)
    @user = user
    @contents = data
    invoice_items
  end

  def count_of(id)
    @contents[id.to_s].to_i
  end

  def item_list
    hash = {}
    @contents.each do |item_id, quantity|
      hash[Item.find(item_id.to_i)] = quantity
    end
    hash
  end



  def invoice
      Invoice.create(user: @user, status: 1)
  end

  def invoice_items
    item_list.map do |item, quantity|
      discount = item.best_discount(quantity)
      if discount.respond_to?('each')
        InvoiceItem.create(quantity: quantity, unit_price: (item.unit_price * ((100 - discount.first.percentage)/100)), discount_id: discount.first.id, status: 0, item: item, invoice: invoice)
      else
        InvoiceItem.create(quantity: quantity, unit_price: item.unit_price, status: 0, item: item, invoice: invoice)
      end
    end
  end
end
