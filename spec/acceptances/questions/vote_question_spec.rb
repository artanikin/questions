require 'acceptance_helper'

feature 'Vote for question', %(
  In order to show my opinion about question
  As an authorized user
  I'd like to be able to vote for question
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthorized user can not vote for question', :js do
    visit questions_path
    within '.rating_block' do
      find(:css, '.glyphicon-chevron-up').click

      expect(page).to have_content '0'
    end
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'Authorized user' do
    before { sign_in(user) }

    describe 'as author this question' do
      scenario 'can not vote', :js do
        question.update(author_id: user.id)
        visit questions_path

        within '.rating_block' do
          find(:css, '.glyphicon-chevron-up').click

          expect(page).to have_content '0'
        end
        expect(page).to have_content 'You can not vote for your question'
      end
    end

    describe 'as not author this question' do
      scenario 'can up vote', :js do
        visit questions_path

        within '.rating_block' do
          find(:css, '.glyphicon-chevron-up').click

          expect(page).to have_content '1'
        end
        expect(page).to have_content 'You voted the question'
      end

      scenario 'can down vote'
    end
  end
end
