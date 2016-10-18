require 'rails_helper'

feature 'User create answer', %(
  To help solve the problev
  As an user
  I want to be able to answer the question
) do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers) }

  scenario 'Authenticate user can answer the question' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Placeholder for answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Placeholder for answer'
  end

  scenario 'Not-authenticate user does not create answer' do
    visit question_path(question)

    expect(page).to have_content 'To answer the question log in'
  end
end
