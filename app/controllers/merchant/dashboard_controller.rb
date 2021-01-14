class Merchant::DashboardController < Merchant::BaseController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
end
