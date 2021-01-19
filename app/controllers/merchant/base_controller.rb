class Merchant::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :set_merchant
  before_action do
    if current_user.merchant == @merchant  || current_user.admin?
      redirect_to new_user_session_path
    else
      flash.notice = "You do not have permission to view this page."
      redirect_to root_path
    end
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
