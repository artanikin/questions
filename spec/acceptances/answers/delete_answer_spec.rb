require 'rails_helper'

feature 'Delete answer', %(
  To hide answer from community
  As an user
  I can to able to remove answer
) do

  given!(:user) { create(:user) }
  given(:question) { create(:question_with_answers) }

  scenario 'Not-authorized user can not remove answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Remove answer'
  end

  scenario 'Author can remove his answer', js: true do
    sign_in(user)
    answer = create(:answer, author: user, question: question, body: 'Small body for answer')

    visit question_path(question)
    click_on 'Remove answer', match: :first

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content answer.body
    expect(page).to have_content 'Your answer successfully removed'
  end

  scenario 'Not-author can not remove not his answer' do
    new_user = create(:user)
    sign_in(new_user)

    visit question_path(question)

    expect(page).to_not have_link 'Remove answer'
  end
end
