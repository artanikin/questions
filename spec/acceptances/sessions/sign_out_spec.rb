require 'acceptance_helper'

feature 'User sign out', %(
  In order to be able close session
  As an user
  I want to be able to sign out
) do

  given(:user) { create(:user) }

  scenario 'Authorized user can sign out' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    click_on 'Sign out'

    expect(page).to have_content 'Sign in'
    expect(current_path).to eq root_path
  end

  scenario 'Not-authorized user can not sign out' do
    visit root_path
    expect(page).to_not have_content 'Sign out'
  end
end
