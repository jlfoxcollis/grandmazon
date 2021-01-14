class Merchant::InvoicesController < Merchant::BaseController
  before_action :set_merchant, only: [:index, :show]
  skip_before_action only: [:create]

  def index
  end

  def create
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
