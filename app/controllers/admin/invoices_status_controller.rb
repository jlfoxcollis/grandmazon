class Admin::InvoicesStatusController < BaseController
  before_action :set_invoice, only: [:update]

  def update
    @invoice.update(invoice_params)
    flash.notice = "#{@invoice.name}'s status was updated successfully!"
    redirect_to admin_merchant_path(@invoice.merchant)
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:status)
  end
end
