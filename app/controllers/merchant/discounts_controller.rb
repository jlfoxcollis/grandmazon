class Merchant::DiscountsController < Merchant::BaseController
  before_action :set_merchant

  def index
  end

  def new
  end

  def create
    discount = @merchant.discounts.new(discount_params)
    if discount.save
      flash[:notice] = "Discount created Successfully!"
      redirect_to merchant_discounts_path(params[:merchant_id])
    else
      discount.errors.full_messages
      render :new
    end
  end

  private

  def discount_params
    params.permit(:name, :percentage, :minimum)
  end

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
