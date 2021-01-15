require "rails_helper"

describe "As a signed in user" do
	describe "I can" do
		before :each do
			@user = create(:user, email: "user@example.com", password: "password", password_confirmation: "password")
			@merchant = create(:merchant, user: @user)
			@customer = create(:customer, user: @user)
			login_as @user
		end
		it 'edit my account info' do
			visit root_path

			click_link "Merchant Account"

			expect(current_path).to eq(edit_user_registration_path)

			fill_in "user[email]", with: "test@example.com"
			fill_in "user[user_name]", with: "test username"
			fill_in "user[first_name]", with: "new name"
			fill_in "user[last_name]", with: "last"
			fill_in "user[password]", with: "password"
			fill_in "user[password_confirmation]", with: "password"
			fill_in "user[current_password]", with: "password"
			click_button "Update"

			expect(@user.reload.first_name).to eq("new name")
			expect(page).to have_content("Your account has been updated successfully.")
			expect(current_path).to eq(root_path)
		end
	end
end
