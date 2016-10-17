require 'rails_helper'

feature 'User create question', %q{
  To get answers to questsions
  As an user
  I can ask a question
} do

  scenario 'User can see the questions' do
    visit questions_path
    expect(current_path).to eq questions_path
  end

  scenario 'User creates question' do
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Title placeholder'
    fill_in 'Body', with: 'Title body'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created'
  end
end
