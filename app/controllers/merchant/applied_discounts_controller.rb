class Merchant::AppliedDiscountsController < Merchant::BaseController

  def index
    @invoice = Invoice.find(params[:invoice_id])
  end
end
