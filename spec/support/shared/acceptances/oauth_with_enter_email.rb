shared_examples_for "Oauth with enter email" do
  describe "user sign_in" do
    background { visit new_user_session_path }

    scenario "user sign_in successfully" do
      clear_emails
      mock_auth_without_email(provider.to_s)
      email = "user@example.com"

      click_on "Sign in with #{provider.capitalize}"

      expect(page).to have_content("Email can\'t be blank")
      fill_in "Email", with: email
      click_on "Sign up"

      open_email(email)
      current_email.click_link "Confirm my account"

      expect(page).to have_content "Your email address has been successfully confirmed"
    end

    context "with invalid credentials" do
      scenario "user not sign_in" do
        mock_auth_invalid(provider.to_sym)
        click_link "Sign in with #{provider.capitalize}"
        expect(page).to have_content("Could not authenticate you from #{provider.capitalize} because \"Credentials are invalid\"")
      end
    end
  end
end
