class Shopping::CheckoutController < ApplicationController

  def index
    @item_list = Item.where(id: cart.contents.keys)
  end

end
