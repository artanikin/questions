shared_examples_for "Acceptance add comments" do
  scenario "Unauthorized user can not add comment" do
    visit question_path(question)

    within "#{comments_block}" do
      expect(page).to_not have_link("add comment")
    end
  end

  context "Authorized user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "can add comment", :js do
      within "#{comments_block}" do
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
        within "#{comments_block}" do
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

  feature "multiple session", :js do
    scenario "comment appears on another user's page" do
      Capybara.using_session("user") do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session("guest") do
        visit question_path(question)
      end

      Capybara.using_session("user") do
        within "#{comments_block}" do
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

      Capybara.using_session("guest") do
        within "#{comments_block}" do
          expect(page).to have_content "Comment placeholder"
        end
      end
    end
  end
end
