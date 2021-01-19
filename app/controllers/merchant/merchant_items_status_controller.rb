class Merchant::MerchantItemsStatusController < Merchant::BaseController
  before_action :set_item, only: [:update]

  def update
    @item.update!(item_params)
    flash.notice = "#{@item.name}'s status was updated successfully!"
    redirect_to merchant_items_path(@merchant)
  end

  private

  def item_params
    params.require(:item).permit(:status)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
