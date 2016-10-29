require 'acceptance_helper'

feature 'Add files to questions', %(
  In order to illustrate my question
  As an author of the question
  I'd like to be able to attach files
) do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks the question' do
    fill_in 'Title', with: 'Title placeholder'
    fill_in 'Body', with: 'Placeholder for body'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end
end
