require 'acceptance_helper'

feature 'Sign in with facebook', %(
  In order to quickly authorized
  As an facebook user
  I want to log in with my facebook account
) do

  describe 'user sign_in' do

    background { visit new_user_session_path }

    scenario 'user sign_in successfully' do
      mock_auth_facebook
      click_on 'Sign in with Facebook'

      expect(page).to have_content('Successfully authenticated from Facebook account')
    end

    context 'with invalid credentials' do
      scenario 'user not sign_in' do
        mock_auth_invalid(:facebook)
        click_link 'Sign in with Facebook'
        expect(page).to have_content('Could not authenticate you from Facebook because "Credentials are invalid"')
      end
    end
  end
end
