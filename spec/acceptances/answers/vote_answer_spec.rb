require 'acceptance_helper'

feature 'Vote for answer', %(
  In order to show my opinion about answer
  As an authorized user
  I'd like to be able to vote for answer
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthorized user can not vote for answer', :js do
    visit question_path(answer)

    within '#answers .rating_block' do
      expect(page).to_not have_css '.glyphicon-chevron-up'
    end
  end

  describe 'Authorized user' do
    before { sign_in(user) }

    describe 'as author this answer' do
      scenario 'can not vote', :js do
        answer.update(author_id: user.id)
        visit question_path(question)

        within '#answers .rating_block' do
          expect(page).to_not have_css '.glyphicon-chevron-up'
        end
      end
    end

    describe 'as not author this answer' do
      scenario 'can vote up', :js do
        visit question_path(question)

        within '#answers .rating_block' do
          find(:css, '.glyphicon-chevron-up').click

          expect(page).to have_content '1'
        end
        expect(page).to have_content 'You voted for answer'
      end

      scenario 'can vote down', :js do
        visit question_path(question)

        within '#answers .rating_block' do
          find(:css, '.glyphicon-chevron-down').click

          expect(page).to have_content '-1'
        end
        expect(page).to have_content 'You voted for answer'
      end

      scenario 'can change vote', :js do
        answer.votes.create(author: user, value: 1)
        visit question_path(question)

        within '#answers .rating_block' do
          expect(page).to have_content '1'

          find(:css, '.glyphicon-chevron-down').click

          expect(page).to have_content '-1'
        end
        expect(page).to have_content 'You voted for answer'
      end

      scenario 'can unvote', :js do
        answer.votes.create(author: user, value: 1)
        visit question_path(question)

        within '#answers .rating_block' do
          expect(page).to have_content '1'

          find(:css, '.glyphicon-chevron-up').click

          expect(page).to have_content '0'
        end
        expect(page).to have_content 'You unvoted for answer'
      end
    end
  end
end
