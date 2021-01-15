require "rails_helper"

describe "As a visitor" do
	describe "I can" do
		it 'Create an account' do
			visit new_user_registration_path

			click_link "Sign Up"

			fill_in "user[email]", with: "test@example.com"
			fill_in "user[user_name]", with: "test username"
			fill_in "user[first_name]", with: "first"
			fill_in "user[last_name]", with: "last"
			fill_in "user[password]", with: "password"
			fill_in "user[password_confirmation]", with: "password"
			click_button "Sign up"

			expect(User.last.email).to eq("test@example.com")
			expect(page).to have_content("Welcome! You have signed up successfully.")
			expect(current_path).to eq(root_path)
		end

		it 'get error w invalid information' do
			visit new_user_registration_path

			click_link "Sign Up"

			fill_in "user[email]", with: "me@example.com"
			fill_in "user[user_name]", with: "test username"
			fill_in "user[first_name]", with: "first"
			fill_in "user[last_name]", with: "last"
			fill_in "user[password]", with: "password"
			fill_in "user[password_confirmation]", with: "xxx"

			click_button "Sign up"
			expect(page).to have_content("Password confirmation doesn't match Password")
			expect(current_path).to eq("/users")
		end
	end
end
