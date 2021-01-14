class Admin::MerchantsController < Admin::BaseController
  before_action :set_merchant, only:[:show, :edit, :update]

  def index
    @merchants_enabled = Merchant.enabled
    @merchants_disabled = Merchant.disabled
    @top_5_merchants = Merchant.top_5_merchants
  end

  def edit
  end

  def show
  end

  def update
    if @merchant.update(merchant_params)
      flash.notice = "Merchant #{@merchant.name} was updated successfully!"
      redirect_to admin_merchant_path(@merchant)
    else
      flash[:error] = @merchant.errors.full_messages
      set_merchant
      render :edit
    end
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
