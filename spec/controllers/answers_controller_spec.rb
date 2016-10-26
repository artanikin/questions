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

      it 'redirect_to log in' do
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

      context 'try update his answer' do
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

      context 'try update not his answer' do
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

      it 'redirect to log in' do
        expect(response.status).to eq 401
      end
    end
  end
end
