require 'rails_helper'

RSpec.describe 'merchants items index page', type: :feature do
  describe 'as a merchant' do
    before(:each) do
      Merchant.destroy_all
      Customer.destroy_all
      Transaction.destroy_all
      Invoice.destroy_all
      User.destroy_all

      @user = create(:user, role: 0)
      @merchant = create(:merchant, user: @user)

      @user1 = create(:user, role: 0)
      @customer_1 = create(:customer, user: @user1)
      @invoice_1 = create(:invoice, merchant: @merchant, customer: @customer_1)
      @invoice_2 = create(:invoice, merchant: @merchant, customer: @customer_1)
      create(:transaction, result: 1, invoice: @invoice_1)
      create(:transaction, result: 1, invoice: @invoice_2)

      @user2 = create(:user, role: 0)
      @customer_2 = create(:customer, user: @user2)
      @invoice_3 = create(:invoice, merchant: @merchant, customer: @customer_2)
      @invoice_4 = create(:invoice, merchant: @merchant, customer: @customer_2)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_4)

      @user3 = create(:user, role: 0)
      @customer_5 = create(:customer, user: @user3)
      @invoice_5 = create(:invoice, merchant: @merchant, customer: @customer_5)
      @invoice_6 = create(:invoice, merchant: @merchant, customer: @customer_5)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_6)

      @user4 = create(:user, role: 0)
      @customer_4 = create(:customer, user: @user4)
      @invoice_7 = create(:invoice, merchant: @merchant, customer: @customer_4)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)

      @user5 = create(:user, role: 0)
      @customer_3 = create(:customer, user: @user5)
      @invoice_8 = create(:invoice, merchant: @merchant, customer: @customer_3)
      create(:transaction, result: 0, invoice: @invoice_7)

      @user6 = create(:user, role: 0)
      @customer_6 = create(:customer, user: @user6)
      @invoice_9 = create(:invoice, merchant: @merchant, customer: @customer_6, created_at: '2010-03-27 14:53:59', status: :completed)
      @invoice_10 = create(:invoice, merchant: @merchant, customer: @customer_6, created_at: '2010-01-27 14:53:59')
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

    it 'can list all item names for specific merchant' do
      visit merchant_items_path(@merchant)
      expected = Item.where(merchant: @merchant).pluck(:name)

      expect(page).to have_content("#{expected[0]}")
      expect(page).to have_content("#{expected[1]}")
      expect(page).to have_content("#{expected[2]}")
      expect(page).to have_link("#{expected[0]}")
    end

    it 'my page has sections for enabled and disabled items and each item has a button that changes its status' do
      item = create(:item, merchant: @merchant, status: 0)

      visit merchant_items_path(@merchant)

      within('#items-disabled') do
        expect(page).to have_content(item.name)
        click_on(id: "btn-enable-#{item.id}")
        expect(current_path).to eq(merchant_items_path(@merchant))
      end

      within('#items-enabled') do
        expect(page).to have_content(item.name)
      end
    end

    it 'has a link to create new item and when a new item is created it is shown on the page' do
      visit merchant_items_path(@merchant)

      click_link('New Item')
      expect(current_path).to eq(new_merchant_item_path(@merchant))
      fill_in 'item_name', with: 'New Item'
      fill_in 'item_unit_price', with: 120
      fill_in 'item_description', with: 'This item is very new and special and cool'
      click_button 'Create Item'

      expect(current_path).to eq(merchant_items_path(@merchant))
      expect(page).to have_content('New Item')
    end

    it 'has a top items section that displays top 5 items and total_revenue for each and historical best day for sales', :skip_before do
      @user = create(:user, role: 1)
      @user1 = create(:user, role: 0)
      @merchant_2 = create(:merchant, user: @user)
      @customer_23 = create(:customer, user: @user1)
      @invoice_33 = create(:invoice, merchant: @merchant_2, customer: @customer_23)
      @invoice_43 = create(:invoice, merchant: @merchant_2, customer: @customer_23)
      create(:transaction, result: 1, invoice: @invoice_33)
      create(:transaction, result: 0, invoice: @invoice_43)

      create_list(:item, 6, merchant: @merchant_2)

      create(:invoice_item, item: @merchant_2.items.fourth, invoice: @invoice_33, quantity: 10, unit_price: 2)#60
      1.times do
        create(:invoice_item, item: @merchant_2.items.first, invoice: @invoice_33, quantity: 10, unit_price: 3)#30
      end

      3.times do
        create(:invoice_item, item: @merchant_2.items.second, invoice: @invoice_33, quantity: 10, unit_price: 4)#120
      end
      create(:invoice_item, item: @merchant_2.items.third, invoice: @invoice_33, quantity: 10, unit_price: 6)#60
      create(:invoice_item, item: @merchant_2.items.fifth, invoice: @invoice_33, quantity: 10, unit_price: 1)#60
      2.times do
        create(:invoice_item, item: @merchant_2.items.third, invoice: @invoice_43, quantity: 10, unit_price: 6)
      end

      login_as(@user, scope: :user)

      visit merchant_items_path(@merchant_2)
      within("#top-items") do
        expected = [@merchant_2.items.second, @merchant_2.items.third, @merchant_2.items.first, @merchant_2.items.fourth, @merchant_2.items.fifth]
        top_5 = @merchant_2.top_5_items

        expect(page).to have_content("#{top_5[0].name} - $#{top_5[0].total_revenue.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}")
        expect(page).to have_content("Top day for #{top_5[0].name} was #{top_5[0].best_day}")

        expect(page).to have_content("#{top_5[2].name} - $#{top_5[2].total_revenue.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}")
        expect(page).to have_content("Top day for #{top_5[2].name} was #{top_5[2].best_day}")

        expect(page).to have_content("#{top_5[4].name} - $#{top_5[4].total_revenue.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}")
        expect(page).to have_content("Top day for #{top_5[4].name} was #{top_5[4].best_day}")

        expect("#{top_5[0].name}").to appear_before("#{top_5[3].name}")
      end
    end
  end
end
