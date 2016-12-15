require "acceptance_helper"

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

  feature "Authenticate user", :js do
    before { sign_in(user) }

    feature "not yet subscribe question", :js do
      scenario "can subscribe to question" do
        visit question_path(question)

        within ".question" do
          click_link "Subscribe"

          expect(page).to have_link("Unsubscribe")
          expect(page).to_not have_link("Subscribe")
        end
        expect(page).to have_content("You successfully subscribe to question")
      end
    end

    feature "already subscribe to question" do
      before { user.subscribes.create(question_id: question.id) }

      scenario "can not subscribe to question" do
        visit question_path(question)

        within ".question" do
          expect(page).to_not have_link("Subscribe")
          expect(page).to have_link("Unsubscribe")
        end
      end

      scenario "can unsubscribe to question", :js do
        visit question_path(question)

        within ".question" do
          click_link "Unsubscribe"

          expect(page).to have_link("Subscribe")
          expect(page).to_not have_link("Unsubscribe")
        end
        expect(page).to have_content("You successfully unsubscribe to question")
      end
    end
  end
end
