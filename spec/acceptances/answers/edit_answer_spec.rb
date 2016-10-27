require 'rails_helper'

feature 'Edit Answer', %(
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit my answer
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticate user can not edit answer' do
    visit question_path(question)
    within '#answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticate user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    describe 'can edit his answer' do
      given!(:answer) { create(:answer, question: question, author: user) }

      scenario 'with valid data', js: true do
        within '#answers' do
          click_on 'Edit'

          fill_in 'Answer', with: 'Edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'Edited answer'
          expect(page).to_not have_selector 'textarea'
        end
        expect(page).to have_content 'Your answer successfully updated'
      end

      scenario 'with invalid data', js: true do
        within '#answers' do
          click_on 'Edit'

          fill_in 'Answer', with: ''
          click_on 'Save'

          expect(page).to have_content 'Body can\'t be blank'
          expect(page).to have_content 'Body is too short (minimum is 10 characters)'
          expect(page).to have_content answer.body
          expect(page).to have_selector 'textarea'
        end
        expect(page).to have_content 'Your answer not updated'
      end
    end

    scenario 'not see link edit if his not author of the answer' do
      within '#answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
