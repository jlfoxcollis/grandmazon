class CartController < ApplicationController
  include ActionView::Helpers::TextHelper

  def show
    @item_list = Item.where(id: cart.contents.keys)
  end

  def update
    item = Item.find(params[:id])
    session[:cart] = cart.contents
    if params[:add_item]
      cart.add_item(item.id)
    elsif params[:remove_item] && cart.count_of(item.id) > 0
      cart.remove_item(item.id)
    end
    quantity = cart.count_of(item.id)
    flash[:notice] = "You now have #{pluralize(quantity, "copy")} of #{item.name} in your cart."
    redirect_to cart_path(cart)
  end

  def destroy
    item = Item.find(params[:id])
    session[:cart] = cart.contents
    cart.delete_item(item.id)
    flash[:notice] = "#{item.name} has been removed from your cart."
    redirect_to cart_path(cart)
  end

end
