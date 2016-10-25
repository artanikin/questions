require 'rails_helper'

feature 'Show resources', %(
  To solve the problem
  As an user
  I can to able take a look questions and answers
) do

  scenario 'User can see the questions' do
    create_list(:question, 3)

    visit questions_path

    expect(page).to have_content('Simple title', count: 3)
  end

  scenario 'User can see the question and answers it', js: true do
    question = create(:question_with_answers)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content('Answer placeholder', count: 2)
  end
end
