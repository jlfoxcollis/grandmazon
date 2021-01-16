class Merchant::DiscountsController < Merchant::BaseController
  before_action :set_merchant
  before_action :set_discount, only: [:show, :edit, :update]

  def index
  end

  def new
  end

  def create
    discount = @merchant.discounts.new(create_params)
    if discount.save
      flash[:notice] = "Discount created Successfully!"
      redirect_to merchant_discounts_path(params[:merchant_id])
    else
      discount.errors.full_messages
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @discount.update(update_params)
      flash.notice = "Discount #{@discount.name} updated successfully!"
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      flash[:error] = @discount.errors.full_messages
      set_discount
      render :edit
    end
  end


  def destroy
    Discount.delete(params[:id])
    render :index
  end

  private

  def create_params
    params.permit(:name, :percentage, :minimum)
  end

  def update_params
    params.require(:discount).permit(:name, :percentage, :minimum)
  end

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def set_discount
    @discount = Discount.find(params[:id])
  end

end
