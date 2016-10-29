require 'acceptance_helper'

feature 'Add files to answers', %(
  In order to illustrate my answer
  As an author of the answer
  I'd like to be able to attach files
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when asks the question' do
    fill_in 'Body', with: 'Placeholder for answer body'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create Answer'

    within '.answers' do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end
end
