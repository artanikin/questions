require "sphinx_acceptance_helper"

feature "Search", %(
  In order to be able to search resource
  As an user
  I'd like to be able to search for resources
) do

  # resources that will search
  given!(:search_question_01) { create(:question, title: "Question 01 with search title") }
  given!(:search_question_02) { create(:question, title: "Question 02 with search title") }
  given!(:search_answer_01) { create(:answer, body: "Answer 01 with search body") }
  given!(:search_answer_02) { create(:answer, body: "Answer 02 with search body") }
  given!(:search_comment_01) { create(:comment, body: "Comment 01 with search body") }
  given!(:search_comment_02) { create(:comment, body: "Comment 02 with search body") }
  given!(:search_user) { create(:user, email: "example@search.ru") }

  # resources that will not search
  given!(:not_search_question) { create(:question, title: "Question with title") }
  given!(:not_search_answer) { create(:answer, body: "Answer with body") }
  given!(:not_search_comment) { create(:comment, body: "Comment with body") }
  given!(:not_search_user) { create(:user, email: "example@mail.ru") }

  background do
    index
    visit(root_path)
    fill_in "q", with: "search"
  end

  scenario "can search from all resources", :js do
    select "All", from: "object"
    click_button "Search"

    within ".searches-list" do
      expect(page).to have_selector(".search-item", count: 7)
      expect(page).to have_content(search_question_01.title)
      expect(page).to have_content(search_question_02.title)
      expect(page).to have_content(search_answer_01.body)
      expect(page).to have_content(search_answer_02.body)
      expect(page).to have_content(search_comment_01.body)
      expect(page).to have_content(search_comment_02.body)
      expect(page).to have_content(search_user.email)
    end
  end

  scenario "can search from questions", :js do
    select "Question", from: "object"
    click_button "Search"

    within ".searches-list" do
      expect(page).to have_selector(".search-item", count: 2)
      expect(page).to have_content(search_question_01.title)
      expect(page).to have_content(search_question_02.title)
    end
  end

  scenario "can search from answers", :js do
    select "Answer", from: "object"
    click_button "Search"

    within ".searches-list" do
      expect(page).to have_selector(".search-item", count: 2)
      expect(page).to have_content(search_answer_01.body)
      expect(page).to have_content(search_answer_02.body)
    end
  end

  scenario "can search from comments", :js do
    select "Comment", from: "object"
    click_button "Search"

    within ".searches-list" do
      expect(page).to have_selector(".search-item", count: 2)
      expect(page).to have_content(search_comment_01.body)
      expect(page).to have_content(search_comment_02.body)
    end
  end

  scenario "can search from users", :js do
    select "Author", from: "object"
    click_button "Search"

    within ".searches-list" do
      expect(page).to have_selector(".search-item", count: 1)
      expect(page).to have_content(search_user.email)
    end
  end
end
