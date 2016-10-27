require 'acceptance_helper'

feature 'Edit Question', %(
  In order to fix mistake
  As an author of question
  I'd like to be able to edit my question
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticate user cant not edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticate user' do
    before { sign_in(user) }

    describe 'can to edit his question' do
      let(:question) { create(:question, author: user) }

      before { visit question_path(question) }

      scenario 'sees link Edit' do
        within '.question' do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'with valid data', js: true do
        within '.question' do
          click_on 'Edit'

          fill_in 'Title', with: 'Changed title'
          fill_in 'Body', with: 'Changed body'
          click_on 'Update Question'

          expect(page).to_not have_selector 'textarea'
        end

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Changed title'
        expect(page).to have_content 'Changed body'
      end

      scenario 'with invalid data', js: true do
        within '.question' do
          click_on 'Edit'

          fill_in 'Title', with: ''
          click_on 'Update Question'
        end

        expect(page).to have_content 'Your question not update'
        expect(page).to have_content 'Title can\'t be blank'
        expect(page).to have_content 'Title is too short (minimum is 10 characters)'
        expect(page).to have_content question.title
      end
    end

    scenario 'not to see edit link' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
