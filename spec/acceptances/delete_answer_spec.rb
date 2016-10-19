require 'rails_helper'

feature 'Delete answer', %(
  To hide answer from community
  As an user
  I can to able to remove answer
) do

  given!(:user) { create(:user_with_question_and_answers, answer_count: 2) }
  given(:question) { user.questions.first }

  scenario 'Not-authorized user can not remove answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Remove answer'
  end

  scenario 'Author can remove his answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Remove answer', match: :first

    expect(current_path).to eq question_path(question)
    expect(page).to have_link('Remove answer', count: 1)
    expect(page).to have_content('Answer placeholder', count: 1)
    expect(page).to have_content 'Your answer successfully removed'
  end

  scenario 'Not-author can not remove not his answer' do
    new_user = create(:user)
    sign_in(new_user)

    visit question_path(question)

    expect(page).to have_content('Answer placeholder', count: 2)
    expect(page).to_not have_link 'Remove answer'
  end
end
