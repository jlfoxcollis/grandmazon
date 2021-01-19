class Merchant::InvoicesController < Merchant::BaseController
  skip_before_action only: [:create]

  def index
  end

  def create
  end

  def show
    @invoice = Invoice.find(params[:id])
  end
end
