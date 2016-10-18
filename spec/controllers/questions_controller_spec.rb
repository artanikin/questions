require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
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
    sign_in_user

    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders view new' do
      expect(response).to render_template :new
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
          expect { post :create, params: parameters }.to change(Question, :count).by(1)
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
end
