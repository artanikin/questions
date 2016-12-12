require "acceptance_helper"

feature "Create question", %(
  To get answers to questions
  As an authenticated user
  I can to able to ask a question
) do

  given(:user) { create(:user) }

  feature "multiple sessions", :js do
    scenario "question appears on another user's page" do
      Capybara.using_session("user") do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session("guest") do
        visit questions_path
      end

      Capybara.using_session("user") do
        click_on "Ask question"

        fill_in "Title", with: "Title placeholder"
        fill_in "Body", with: "Placeholder for body"
        click_on "Create"

        expect(page).to have_content "Title placeholder"
        expect(page).to have_content "Placeholder for body"
      end

      Capybara.using_session("guest") do
        expect(page).to have_content "Title placeholder"
      end
    end
  end


  feature "Authenticated user" do
    before do
      sign_in(user)

      visit questions_path
      click_on "Ask question"
    end

    scenario "can create question with valid attributes" do
      fill_in "Title", with: "Title placeholder"
      fill_in "Body", with: "Placeholder for body"
      click_on "Create"

      expect(page).to have_content "Question was successfully created"
      expect(page).to have_content "Title placeholder"
      expect(page).to have_content "Placeholder for body"
      expect(page).to have_link "Unsubscribe"
      expect(current_path).to eq question_path(Question.last)
    end

    scenario "can not create question with invalid attributes" do
      fill_in "Title", with: ""
      fill_in "Body", with: ""
      click_on "Create"

      expect(page).to have_content("Question could not be created")
    end
  end

  scenario "Not-authenticated user does not create question" do
    visit questions_path
    expect(page).to_not have_link "Ask question"
  end
end
