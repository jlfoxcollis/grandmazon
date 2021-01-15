require "rails_helper"

describe "As an existing user" do
	describe "I can" do
		before :each do
			@user = create(:user, email: "user@example.com", password: "password", password_confirmation: "password")
			@merchant = create(:merchant, user: @user)
			@user1 = create(:user, email: "user1@example.com", password: "password", password_confirmation: "password")
			@merchant = create(:merchant, user: @user1)
			@user2 = create(:user, email: "user2@example.com", password: "password", password_confirmation: "password")
			@merchant = create(:merchant, user: @user2)
		end

		it 'login' do
			visit root_path

			click_link "Login"

			expect(current_path).to eq(new_user_session_path)

			fill_in "user[email]", with: "user@example.com"
			fill_in "user[password]", with: "password"
			click_button "Log in"

			expect(page).to have_content("Signed in successfully.")
			expect(current_path).to eq(root_path)
		end

		it 'login w/ invalid credentials' do
			visit root_path

			click_link "Login"

			expect(current_path).to eq(new_user_session_path)

			fill_in "user[email]", with: "user@example.com"
			fill_in "user[password]", with: "xxxxx"
			click_button "Log in"

			expect(page).to have_content("Invalid Email or password.")
			expect(current_path).to eq(new_user_session_path)
		end

		it 'logout customer' do
			login_as @user
			visit root_path
			click_link "Log Out"
			expect(page).to have_content("Signed out successfully.")
			expect(current_path).to eq(root_path)
		end
	end
end
