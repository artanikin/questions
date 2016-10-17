require 'rails_helper'

feature 'User sign in', %(
  In order to be able to ask question
  As an user
  I want to be able to sign in
) do

  scenario 'Registered user try to sign in' do
    User.create!(email: 'user@example.com', password: 'pass123')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'pass123'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'pass123'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Authorized user can sign out' do
    User.create!(email: 'user@example.com', password: 'pass123')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'pass123'
    click_on 'Log in'

    click_on 'Sign out'

    expect(page).to have_content 'Sign in'
    expect(current_path).to eq root_path
  end
end
