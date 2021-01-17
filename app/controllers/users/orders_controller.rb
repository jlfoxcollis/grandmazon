class Users::OrdersController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :set_order, only: [:show]

  def index
    @orders = current_user.invoices
  end


  def new
  end

  def create
    order = Order.new(cart.contents, current_user)
    order.invoice_items
    session[:cart].clear
    redirect_to user_order_path(current_user.id, order.invoice)
  end

  def show
  end

  private

  def set_order
    @order = Invoice.find(params[:id])
  end


end
