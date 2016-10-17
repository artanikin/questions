require 'rails_helper'

feature 'User create answer', %(
  To help solve the problev
  As an user
  I want to be able to answer the question
) do

  given(:question) { create(:question_with_answers) }

  scenario 'User can see the question and answers it' do
    visit question_path(question)

    expect(current_path).to eq question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content('Answer placeholder', count: 5)
  end

  scenario 'User can answer the question' do
    visit question_path(question)

    fill_in 'Body', with: 'Placeholder for answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Placeholder for answer'
  end
end