require 'acceptance_helper'

feature "Add comments for answer", %(
  In order to clarify the issue
  As an authorized user
  I'd like to be able to add comment for answer
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario "Unauthorized user can not add comment" do
    visit question_path(question)

    within "#answers .answer .comments" do
      expect(page).to_not have_link("add comment")
    end
  end

  context "Authorized user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "can add comment", :js do
      within "#answers .answer .comments" do
        click_on "add comment"

        expect(page).to_not have_link 'add comment'

        fill_in "Your Comment", with: "Comment placeholder"
        click_on 'Save'

        expect(page).to have_link "add comment"
        expect(page).to_not have_selector "textarea"
        expect(page).to have_content "Comment placeholder"
      end
      expect(page).to have_content "Your comment successfully added"
    end

    context 'with invalid params' do
      scenario "can't add comment", :js do
        within "#answers .answer .comments" do
          click_on "add comment"

          expect(page).to_not have_link 'add comment'

          fill_in "Your Comment", with: ""
          click_on 'Save'

          expect(page).to have_content "can't be blank"
          expect(page).to have_content "is too short (minimum is 10 characters)"
          expect(page).to_not have_content "Comment placeholder"
        end
        expect(page).to have_content "Your comment not added"
      end
    end
  end
end
