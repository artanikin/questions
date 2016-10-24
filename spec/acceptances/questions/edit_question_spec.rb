require 'rails_helper'

feature 'Edit Question', %(
  In order to fix mistake
  As an author of question
  I'd like to be able to edit my question
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticate user try edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticate user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    describe 'try to edit his question' do
      scenario 'sees link Edit' do
        within '.question' do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'with valid data', js: true do
        pending
        within '.question' do
          click_on 'Edit'

        end
        within '.question form' do
          fill_in 'Title', with: 'Changed title'
          fill_in 'Body', with: 'Changed body'
          click_on 'Update Question'
        end

        # expect(page).to_not have_content question.title
        # expect(page).to_not have_content question.body
        expect(page).to have_content 'Changed title'
        expect(page).to have_content 'Changed body'
        expect(page).to_not have_selector 'textarea'
      end

      scenario 'with invalid data'
    end
    scenario 'try to edit not his question'
  end
end
