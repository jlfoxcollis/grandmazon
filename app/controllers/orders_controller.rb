class OrdersController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
    @order = Order.new(cart.contents, current_user)
    @order.invoices
    @order.invoice_items
    redirect_to customer_path(current_user.id)
  end
end
