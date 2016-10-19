require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:parameters) do
      { question_id: question, answer: attributes_for(:answer) }
    end

    describe 'Authorized user' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new answer in database' do
          expect { post :create, params: parameters }
            .to change(question.answers.where(author: @user), :count).by(1)
        end

        it 'redirect to question show view' do
          post :create, params: parameters
          expect(response).to redirect_to question
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

    describe 'Non-authorized user can not create answer' do
      it 'can not create answer' do
        expect { post :create, params: parameters }.to_not change(Answer, :count)
      end

      it 'redirect_to log in' do
        post :create, params: parameters
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'Authorized user' do
      sign_in_user

      context 'author' do
        before do
          @question = create(:question_with_answers, answers_count: 1, author: @user)
          answer_params(@question)
        end

        it 'delete answer' do
          expect { delete :destroy, params: @parameters }.to change(@question.answers, :count).by(-1)
        end

        it 'render index views' do
          delete :destroy, params: @parameters
          expect(response).to redirect_to question_path(@question)
        end
      end

      context 'not author' do
        it 'can not delete answer' do
          question = create(:question_with_answers, answers_count: 1)
          answer_params(question)
          expect { delete :destroy, params: @parameters }.to_not change(question.answers, :count)
        end
      end
    end
  end

  describe 'Non-authorized user' do
    before do
      @question = create(:question_with_answers)
      answer_params(@question)
    end

    it 'can not delete answer' do
      expect { delete :destroy, params: @parameters }.to_not change(@question.answers, :count)
    end

    it 'redirect_to log in' do
      delete :destroy, params: @parameters
      expect(response).to redirect_to new_user_session_path
    end
  end
end
