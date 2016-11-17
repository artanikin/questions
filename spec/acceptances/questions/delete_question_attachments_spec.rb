require 'acceptance_helper'

feature 'Delete question attachment', %(
  In order to remove wrong file
  As an author the question
  I'd like to be able to remove attachment
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Unauthenticate user not see remove link' do
    visit question_path(question)
    expect(page).to_not have_link('x')
  end

  describe 'Authorized user' do
    scenario 'can to delete his attachment', :js do
      sign_in(user)
      visit question_path(question)

      within '.question .attachments' do
        click_on 'x'
      end

      expect(page).to_not have_link('x', href: '/uploads/attachment/file/1/spec_helper.rb')
      expect(page).to have_content 'File was deleted'
    end

    scenario 'not see remove link', :js do
      question.update(author: create(:user))
      visit question_path(question)

      expect(page).to_not have_link('x')
    end
  end
end
