require 'acceptance_helper'

feature 'Sign in with twitter', %(
  In order to quickly authorized
  As an twitter user
  I want to log in with my twitter account
) do

  describe 'user sign_in' do

    background { visit new_user_session_path }

    scenario 'user sign_in successfully' do
      clear_emails
      mock_auth_without_email('twitter')
      email = 'user@example.com'

      click_on 'Sign in with Twitter'

      expect(page).to have_content('Email can\'t be blank')
      fill_in 'Email', with: email
      click_on 'Sign up'

      open_email(email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed'
    end

    context 'with invalid credentials' do
      scenario 'user not sign_in' do
        mock_auth_invalid(:twitter)
        click_link 'Sign in with Twitter'
        expect(page).to have_content('Could not authenticate you from Twitter because "Credentials are invalid"')
      end
    end
  end
end
