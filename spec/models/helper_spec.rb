require 'rails_helper'
include ApplicationHelper

RSpec.describe 'Helper Methods' do
  describe 'Status attribute' do
    it '#enum_collection_for_select' do
      invoice_item_expected = [["", ""], ["Pending", "pending"], ["Packaged", "packaged"], ["Shipped", "shipped"]]
      invoice_expected = [["", ""], ["Cancelled", "cancelled"], ["In Progress", "in_progress"], ["Completed", "completed"]]
      item_or_merchant_expected = [["", ""], ["Disabled", "disabled"], ["Enabled", "enabled"]]
      transaction_expected = [["", ""], ["Failed", "failed"], ["Success", "success"]]


      expect(enum_collection_for_select(InvoiceItem.statuses)).to eq(invoice_item_expected)
      expect(enum_collection_for_select(Invoice.statuses)).to eq(invoice_expected)
      expect(enum_collection_for_select(Item.statuses)).to eq(item_or_merchant_expected)
      expect(enum_collection_for_select(Merchant.statuses)).to eq(item_or_merchant_expected)
      expect(enum_collection_for_select(Transaction.results)).to eq(transaction_expected)
    end
  end
end