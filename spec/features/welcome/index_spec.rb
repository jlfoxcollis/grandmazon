require 'rails_helper'

describe "As a visitor" do
	describe "when i visit the root path" do
		it 'I can see all of the items with enabled merchants' do
			@user1 = create(:user)
			@user2 = create(:user)

			@merchant_1 = create(:merchant, user: @user1, status: 1)
			@merchant_2 = create(:merchant, user: @user2)

			@item1 = create(:item, name: "A", merchant: @merchant_1)
			@item2 = create(:item, name: "B", merchant: @merchant_1)
			@item3 = create(:item, name: "C", merchant: @merchant_1)
			@item4 = create(:item, name: "D", merchant: @merchant_1)

			@item5 = create(:item, name: "A", merchant: @merchant_2)
			@item6 = create(:item, name: "B", merchant: @merchant_2)
			@item7 = create(:item, name: "C", merchant: @merchant_2)
			@item8 = create(:item, name: "D", merchant: @merchant_2)

			visit root_path

			expect(page).to have_content(@merchant_1.name)
			expect(page).to have_content(@merchant_2.name)

		end
	end
end
