require "rails_helper"

describe "As a signed in user", type: :feature do
	describe "I can" do
		before :each do
			@user = create(:user, email: "user@example.com", password: "password", password_confirmation: "password")
			@merchant = create(:merchant, user: @user)
			login_as @user
		end
		it 'delete my account info' do
			visit root_path
			click_link "My Account"
			click_link "Edit Account"

			expect(current_path).to eq(edit_user_registration_path(@user))

			click_button "Cancel my account"

			expect(User.last).to_not eq(@user)
			expect(page).to have_content("Bye! Your account has been successfully cancelled. We hope to see you again soon.")
			expect(current_path).to eq(root_path)
		end
	end
end
