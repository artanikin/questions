require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:parameters) do
      { question_id: question, answer: attributes_for(:answer), format: :js }
    end

    describe 'Authorized user' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new answer in database' do
          expect { post :create, params: parameters }
            .to change(question.answers.where(author: @user), :count).by(1)
        end

        it 'render temlate create' do
          post :create, params: parameters
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        let(:parameters) do
          { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        end

        it 'does not save the answer' do
          expect { post :create, params: parameters }.to_not change(Answer, :count)
        end

        it 'render create template' do
          post :create, params: parameters
          expect(response).to render_template :create
        end
      end
    end

    describe 'Non-authorized user can not create answer' do
      it 'can not create answer' do
        expect { post :create, params: parameters }.to_not change(Answer, :count)
      end

      it 'get 401 status Unauthorized' do
        post :create, params: parameters
        expect(response.status).to eq 401
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
          expect { delete :destroy, params: @parameters, format: :js }
            .to change(@question.answers, :count).by(-1)
        end

        it 'render destroy template' do
          delete :destroy, params: @parameters, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'not author' do
        it 'can not delete answer' do
          question = create(:question_with_answers, answers_count: 1)
          answer_params(question)
          expect { delete :destroy, params: @parameters, format: :js }
            .to_not change(question.answers, :count)
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

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question) }

    describe 'authorized user' do
      sign_in_user

      context 'can update his answer' do
        let(:answer) { create(:answer, question: question, author: @user) }

        context 'with valid attributes' do
          before do
            patch :update, params: { id: answer.id, format: :js, answer: { body: 'Change answer' } }
          end

          it 'change answer' do
            expect(answer.reload.body).to eq 'Change answer'
          end

          it 'render update template' do
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before do
            patch :update, params: { id: answer.id, format: :js, answer: { body: '' } }
          end

          it 'not change answer' do
            expect(answer.reload.body).to eq 'Answer placeholder'
          end

          it 'render update template' do
            expect(response).to render_template :update
          end
        end
      end

      context 'can not update not his answer' do
        before do
          patch :update, params: { id: answer.id, format: :js, answer: { body: 'Change answer' } }
        end

        it 'not change answer' do
          expect(answer.reload.body).to_not eq 'Change answer'
        end

        it 'render update template' do
          expect(response).to render_template :update
        end
      end
    end

    describe 'unauthorized user' do
      before do
        patch :update, params: { id: answer.id, format: :js, answer: { body: 'Change answer' } }
      end

      it 'can not update answer' do
        expect(answer.body).to_not eq 'Change answer'
      end

      it 'get 401 status Unauthorized' do
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH #best' do
    describe 'Unauthorized user' do
      it 'get 401 status Unauthorized' do
        answer = create(:answer, question: question)
        patch :best, params: { id: answer, format: :js }

        expect(response.status).to eq 401
      end
    end

    describe 'Authorized user' do
      sign_in_user

      context 'as the author of the question' do
        let!(:question) { create(:question, author: @user) }
        let!(:answer1) { create(:answer, question: question) }
        let!(:answer2) { create(:answer, question: question, best: true) }

        before do
          patch :best, params: { id: answer1, format: :js }
        end

        it 'assigns answer' do
          expect(assigns(:answer)).to eq answer1
        end

        it 'set answer as best' do
          expect(answer1.reload).to be_best
          expect(answer2.reload).to_not be_best
        end

        it 'render best template' do
          expect(response).to render_template :best
        end
      end

      context 'as non author of the question' do
        let!(:question) { create(:question) }
        let!(:answer) { create(:answer, question: question) }

        it 'can not mark answer as best' do
          expect { patch :best, params: { id: answer, format: :js } }.to_not change(answer, :best)
        end
      end
    end
  end
end
