require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #up' do
    let(:parameters) { {votable_type: 'Question', votable_id: question.id} }

    describe 'Unauthorized user' do
      it 'can not vote up for question' do
        expect { post :up, params: parameters }.to_not change(question.votes, :count)
      end
    end
  end

  describe 'POST #down'
end
