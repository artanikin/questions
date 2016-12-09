require 'acceptance_helper'

feature "Subsribe to question", %(
  In oreder to get notification for new answers
  As an user signed by the question
  I'd like to be able to get notification of new replies for question
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario "Unauthenticate user can not subsribe to question" do
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_link "Subscribe"
    end
  end

  describe "Authenticate user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    describe "not yet subscribe question" do
      scenario "can subscribe to question" do
        within ".question" do
          click_link "Subscribe"

          expect(page).to have_link("Unsubscribe")
          expect(page).to have_content("You successfull subscribe to question")
          expect(page).to have_link("Subscribe")
        end
      end
    end

    describe "already subscribe to question" do
      scenario "can not subscribe to question" do
        expect(page).to_not have_link("Subscribe")
        expect(page).to have_link("Unsubscribe")
      end
    end
  end
end
