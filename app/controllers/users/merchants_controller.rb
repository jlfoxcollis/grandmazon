class Users::MerchantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_merchant, only: [:show, :edit, :update]

  def new
    @merchant = Merchant.new
  end

  def create
      if @merchant = current_user.create_merchant(merchant_params) &&
        current_user.update(user_params)
      flash.notice = "Merchant profile was created Successfully!"
      redirect_to user_path(current_user)
    else
      flash[:error] = @merchant.errors.full_messages
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @merchant.update(merchant_params)
      flash.notice = "Merchant profile was updated Successfully!"
      redirect_to user_merchant_path(current_user, @merchant)
    else
      flash[:error] = merchant.errors.full_messages
      set_merchant
      render :edit
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end

  def user_params
    params.require(:merchant).permit(:merchant)
  end
end
