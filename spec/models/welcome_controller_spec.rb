require 'rails_helper'

describe WelcomeController, type: :controller do
  describe "Get index" do
    it 'assigns @merchants' do
      merchant = Merchant.create(name: "bob")
      get :index

      cart ||= Cart.new("data")
      expect(cart).to be_a(Cart)
      expect(merchant).to be_a(Merchant)
    end
  end
end
