require 'rails_helper'

feature 'User create answer', %(
  To help solve the problev
  As an user
  I want to be able to answer the question
) do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers) }

  feature 'Authenticate user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can answer the question with valid attributes' do
      fill_in 'Body', with: 'Placeholder for answer'
      click_on 'Create Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Placeholder for answer'
    end

    scenario 'can not answer there question with invalid attributes' do
      fill_in 'Body', with: ''
      click_on 'Create Answer'

      expect(page).to have_content 'Your answer not created. Check the correctness of filling the fields.'
      expect(page).to have_content('Answer placeholder', count: 2)
    end
  end

  scenario 'Not-authenticate user does not create answer' do
    visit question_path(question)

    expect(page).to have_content 'To answer the question log in'
  end
end
