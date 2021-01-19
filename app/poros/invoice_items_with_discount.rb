class InvoiceItemsWithDiscount

  def self.update_percentage(invitems)
    invitems.each do |invitem|
      applied = Discount.find(invitem.discount_id)
      invitem.update({discount_percent: applied.percentage})
    end
  end
end
