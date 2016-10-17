require 'rails_helper'

feature 'Create question', %(
  To get answers to questsions
  As an authenticated user
  I can to able to ask a question
) do

  scenario 'User can see the questions' do
    visit questions_path
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user creates question' do
    User.create!(email: 'user@example.com', password: 'pass123')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'pass123'
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Title placeholder'
    fill_in 'Body', with: 'Placeholder for body'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Title placeholder'
    expect(current_path).to eq question_path(Question.last)
  end

  scenario 'Non-uthenticated user creates question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end
