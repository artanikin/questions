require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'Voted'

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'it populates array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'assigns to requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render view show' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    describe 'Authorized user' do
      sign_in_user

      before { get :new }

      it 'assigns new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders view new' do
        expect(response).to render_template :new
      end
    end

    describe 'Non-authorized user' do
      it 'redirect_to log in' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    let(:parameters) do
      { question: attributes_for(:question) }
    end

    describe 'Authorized user' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new question in database' do
          expect { post :create, params: parameters }.to change(@user.questions, :count).by(1)
        end

        it 'redirect to show view' do
          post :create, params: parameters
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'with invalid attributes' do
        let(:parameters) do
          { question: attributes_for(:invalid_question) }
        end

        it 'does not save the question' do
          expect { post :create, params: parameters }.to_not change(Question, :count)
        end

        it 're-render view new' do
          post :create, params: parameters
          expect(response).to render_template :new
        end
      end
    end

    describe 'Non-authorized user' do
      it 'can not create question' do
        expect { post :create, params: parameters }.to_not change(Question, :count)
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
        let(:question) { create(:question, author: @user) }

        before { question }

        it 'delete question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it 'render index views' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'not author' do
        it 'can not delete question' do
          question = create(:question)
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end
      end
    end

    describe 'Non-authorized user' do
      let(:question) { create(:question) }

      before { question }

      it 'can not delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect_to log in' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Authenticated user' do
      sign_in_user

      context 'can edit his question' do
        let(:question) { create(:question, author: @user) }

        context 'with valid data' do
          before do
            patch :update, params: { id: question, format: :js,
                                     question: { title: 'Changed title', body: 'Changed body' } }
          end

          it 'changed question attributes' do
            question.reload
            expect(question.title).to eq 'Changed title'
            expect(question.body).to eq 'Changed body'
          end

          it 'render to update template' do
            expect(response).to render_template :update
          end
        end

        context 'with invalid data' do
          before do
            patch :update, params: { id: question, format: :js, question: { title: nil } }
          end

          it 'not changed question attributes' do
            question.reload
            expect(question.title).to eq 'Simple title'
            expect(question.body).to eq 'Placeholder for body'
          end

          it 'render update template' do
            expect(response).to render_template :update
          end
        end

      end

      context 'can not edit not his question' do
        it 'can not update question' do
          question = create(:question)
          patch :update,
            params: { id: question, format: :js,
                      question: { title: 'Change title', body: 'Change body' } }
          question.reload

          expect(question.title).to_not eq 'Change title'
          expect(question.body).to_not eq 'Change body'
        end
      end

    end

    describe 'Unauthenticated user' do
      it 'get 401 status Unauthorized' do
        question = create(:question)

        patch :update,
          params: { id: question, format: :js,
                    question: { title: 'Change title', body: 'Change body' } }
        expect(response.status).to eq 401
      end
    end
  end
end
