class Merchant::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :set_merchant
  before_action :check_merchant


  private

  def set_merchant
    @merchant ||= Merchant.find(params[:merchant_id])
  end

  def check_merchant
      redirect_to root_path, notice: "You do not have permission to view this page." unless current_user.merchant == @merchant  || current_user.admin?
  end


end
