class Admin::InvoicesStatusController < Admin::BaseController
  before_action :set_invoice, only: [:update]

  def update
    @invoice.update(invoice_params)
    @invoice.invoice_complete_update_invoice_items
    flash.notice = "Invoice successfully updated!"
    redirect_to admin_invoice_path(@invoice)
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:status)
  end
end
