require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:attr) { attributes_for(:answer) }

      it 'saves the new answer in database' do
        expect { post :create, params: { question_id: question, answer: attr } }
          .to change(question.answers, :count).by(1)
      end

      it 'redirect to question show view' do
        post :create, params: { question_id: question, answer: attr }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attr) { attributes_for(:invalid_answer) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: invalid_attr } }
          .to_not change(Answer, :count)
      end

      it 're-render question/show view' do
        post :create, params: { question_id: question, answer: invalid_attr }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
