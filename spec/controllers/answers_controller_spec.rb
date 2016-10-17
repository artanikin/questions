require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:parameters) do
        { question_id: question, answer: attributes_for(:answer) }
      end

      it 'saves the new answer in database' do
        expect { post :create, params: parameters }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question show view' do
        post :create, params: parameters
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      let(:parameters) do
        { question_id: question, answer: attributes_for(:invalid_answer) }
      end

      it 'does not save the answer' do
        expect { post :create, params: parameters }.to_not change(Answer, :count)
      end

      it 're-render question/show view' do
        post :create, params: parameters
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
