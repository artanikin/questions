require 'acceptance_helper'

feature 'Vote for question', %(
  In order to show my opinion about question
  As an authorized user
  I'd like to be able to vote for question
) do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Unauthorized user can not vote for question'

  describe 'Authorized user' do
    scenario 'as author this question can not vote'

    describe 'as not author this question' do
      scenario 'can up vote'
      scenario 'can down vote'
    end
  end
end
