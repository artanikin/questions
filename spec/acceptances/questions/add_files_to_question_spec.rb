require 'acceptance_helper'

feature 'Add files to questions', %(
  In order to illustrate my question
  As an author of the question
  I'd like to be able to attach files
) do

  given(:user) { create(:user) }
  given(:path) { new_question_path }
  given(:title?) { true }
  given(:submit_btn) { "Create" }
  given(:attachment_block) { ".question" }

  it_behaves_like "Add attachments"
end
