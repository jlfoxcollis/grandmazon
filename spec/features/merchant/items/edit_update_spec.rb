require 'rails_helper'

RSpec.describe 'merchants can update items', type: :feature do
  describe 'as a merchant' do
    before(:each) do
      Merchant.destroy_all
      Transaction.destroy_all
      Invoice.destroy_all
      User.destroy_all

      @user = create(:user)
      @merchant = create(:merchant, user: @user)

      @user1 = create(:user)
      @invoice_1 = create(:invoice, user: @user1)
      @invoice_2 = create(:invoice, user: @user1)
      create(:transaction, result: 1, invoice: @invoice_1)
      create(:transaction, result: 1, invoice: @invoice_2)

      @user2 = create(:user)
      @invoice_3 = create(:invoice, user: @user2)
      @invoice_4 = create(:invoice, user: @user2)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_4)

      @user3 = create(:user)
      @invoice_5 = create(:invoice, user: @user3)
      @invoice_6 = create(:invoice, user: @user3)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_6)

      @user4 = create(:user)
      @invoice_7 = create(:invoice, user: @user4)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)

      @user5 = create(:user)
      @invoice_8 = create(:invoice, user: @user5)
      create(:transaction, result: 0, invoice: @invoice_7)

      @user6 = create(:user)
      @invoice_9 = create(:invoice, user: @user6, created_at: '2010-03-27 14:53:59', status: :completed)
      @invoice_10 = create(:invoice, user: @user6, created_at: '2010-01-27 14:53:59')
      create(:transaction, result: 1, invoice: @invoice_9)

      create_list(:item, 3, merchant: @merchant)

      5.times do
        create(:invoice_item, item: Item.first, invoice: Invoice.all.sample, status: 2)
      end

      2.times do
        create(:invoice_item, item: Item.second, invoice: @invoice_9, status: 1)
      end
      3.times do
        create(:invoice_item, item: Item.second, invoice: @invoice_7, status: 1)
      end

      5.times do
        create(:invoice_item, item: Item.third, invoice: Invoice.all.sample, status: 0)
      end
      login_as(@user, scope: :user)
    end

    it 'can update and see items info in form' do
      item = @merchant.items.first
      visit merchant_item_path(@merchant.id, item.id)

      click_on 'Edit Item'

      expect(current_path).to eq(edit_merchant_item_path(@merchant.id, item.id))
      expect(page).to have_field('item[name]', with: "#{item.name}")

      fill_in 'item[name]', with: "fruit"
      fill_in 'item[description]', with: "not a real fruit"
      fill_in 'item[unit_price]', with: 42

      click_button("Update Item")
      expect(current_path).to eq(merchant_item_path(@merchant.id, item.id))
      expect(page).to have_content("Item successfully updated")
    end

    it 'displays flash message if validations fail' do
      item = @merchant.items.first
      visit merchant_item_path(@merchant.id, item.id)

      click_on 'Edit Item'

      expect(current_path).to eq(edit_merchant_item_path(@merchant.id, item.id))
      expect(page).to have_field('item[name]', with: "#{item.name}")

      fill_in 'item[name]', with: "fruit"
      fill_in 'item[description]', with: "not a real fruit"
      fill_in 'item[unit_price]', with: "xxxx"

      click_button("Update Item")
      expect(current_path).to eq(merchant_item_path(@merchant.id, item.id))
      expect(page).to have_content("Unit price is not a number")
    end
  end
end
