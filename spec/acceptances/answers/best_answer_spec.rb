require 'rails_helper'

feature 'Best answer', %(
  To mark solution for the question
  As an author of the question
  I want to be able to mark the answer of the best
) do

  given!(:user) { create(:user) }

  scenario 'Unauthorized user try mark the answer as best' do
    question = create(:question_with_answers)
    visit question_path(question)
    expect(page).to_not have_link('Best')
  end

  describe 'Authorized user' do
    before { sign_in(user) }

    scenario 'as author of question try mark the answer as best', js: true do
      question = create(:question, author: user)
      answer1 = create(:answer, question: question, body: 'This is answer number 1')
      answer2 = create(:answer, question: question, best: true)

      visit question_path(question)

      within "#answer_#{answer1.id}" do
        click_on 'Best'

        expect(page).to have_content 'Best answer'
        expect(page).to_not have_link('Best')
      end

      within "#answer_#{answer2.id}" do
        expect(page).to have_link('Best')
        expect(page).to_not have_content 'Best answer'
      end

      expect(page).to have_content 'Answer mark as Best'

      first_answer_text = page.find(:css, '.answer', match: :first).text
      expect(first_answer_text).to have_content answer1.body
      expect(first_answer_text).to have_content 'Best answer'
    end

    scenario 'as non author the question try mark the answer as best' do
      question = create(:question_with_answers)
      answer = create(:answer, question: question, best: true)

      visit question_path(question)

      within "#answer_#{answer.id}" do
        expect(page).to have_content 'Best answer'
      end
      expect(page).to_not have_link 'Best'
    end
  end

end
