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
    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders view new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:parameters) do
        { question: attributes_for(:question) }
      end

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
end
