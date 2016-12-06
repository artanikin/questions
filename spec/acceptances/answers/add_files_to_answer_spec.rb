require 'acceptance_helper'

feature 'Add files to answers', %(
  In order to illustrate my answer
  As an author of the answer
  I'd like to be able to attach files
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:path) { question_path(question) }
  given(:title?) { false }
  given(:submit_btn) { "Create Answer" }
  given(:attachment_block) { "#answers" }

  it_behaves_like "Add attachments"
end
