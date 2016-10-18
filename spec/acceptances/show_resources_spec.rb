require 'rails_helper'

feature 'Show resources', %(
  To solve the problem
  As an user
  I can to able take a look questions and answers
) do

  scenario 'User can see the questions' do
    visit questions_path
    expect(current_path).to eq questions_path
  end

  scenario 'User can see the question and answers it' do
    question = create(:question_with_answers)

    visit question_path(question)

    expect(current_path).to eq question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content('Answer placeholder', count: 2)
  end
end
