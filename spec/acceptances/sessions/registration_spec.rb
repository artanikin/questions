require 'acceptance_helper'

feature 'User register', %(
  In order to be able to ask a question
  As an user
  I want to be able to register
) do

  scenario 'user can register' do
    email = 'user@example.com'

    clear_emails
    visit new_user_registration_path
    fill_in 'Email', with: email
    fill_in 'Password', with: 'pass123'
    fill_in 'Password confirmation', with: 'pass123'
    click_on 'Sign up'

    expect(page).to have_content 'Toggle navigation Questions Sign in A message with a confirmation link has been sent to your email'
    expect(current_path).to eq root_path

    open_email(email)
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed'
  end

  scenario 'user can not register without email' do
    visit new_user_registration_path
    fill_in 'Password', with: 'pass123'
    fill_in 'Password confirmation', with: 'pass123'
    click_on 'Sign up'

    expect(page).to have_content 'Email can\'t be blank'
  end

  scenario 'user can not register when password not confirm' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'pass123'
    fill_in 'Password confirmation', with: 'pass12345'
    click_on 'Sign up'

    expect(page).to have_content 'Password confirmation doesn\'t match Password'
  end
end
