require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like "Voted"

  describe "GET #index" do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it "it populates array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it "assigns to requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "render view show" do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    describe "Authorized user" do
      sign_in_user

      before { get :new }

      it "assigns new Question to @question" do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it "renders view new" do
        expect(response).to render_template :new
      end
    end

    describe "Non-authorized user" do
      it "redirect_to log in" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    let(:parameters) { { question: attributes_for(:question) } }

    subject { post :create, params: parameters }

    describe "Authorized user" do
      sign_in_user

      context "with valid attributes" do
        it "saves the new question in database" do
          expect { subject }.to change(@user.questions, :count).by(1)
        end

        it "subscribe author to question" do
          expect { subject }.to change(@user.subscribes, :count).by(1)
        end

        it "redirect to show view" do
          subject
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context "with invalid attributes" do
        let(:parameters) { { question: attributes_for(:invalid_question) } }

        it "does not save the question" do
          expect { subject }.to_not change(Question, :count)
        end

        it "re-render view new" do
          subject
          expect(response).to render_template :new
        end
      end
    end

    describe "Non-authorized user" do
      it "can not create question" do
        expect { subject }.to_not change(Question, :count)
      end

      it "redirect_to log in" do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:question) { create(:question) }

    subject { delete :destroy, params: { id: question } }

    describe "Authorized user" do
      sign_in_user

      context "author" do
        before { question.update(author: @user) }

        it "delete question" do
          expect { subject }.to change(Question, :count).by(-1)
        end

        it "render index views" do
          subject
          expect(response).to redirect_to questions_path
        end
      end

      context "not author" do
        it "can not delete question" do
          expect { subject }.to_not change(Question, :count)
        end
      end
    end

    describe "Non-authorized user" do
      it "can not delete question" do
        expect { subject }.to_not change(Question, :count)
      end

      it "redirect_to log in" do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #update" do
    let!(:question) { create(:question) }
    let(:parameters) do
      { id: question, format: :js, question: { title: "Changed title", body: "Changed body" } }
    end

    subject { patch :update, params: parameters }

    describe "Authenticated user" do
      sign_in_user

      context "can edit his question" do
        before { question.update(author: @user) }

        context "with valid data" do
          before { subject }

          it "changed question attributes" do
            question.reload
            expect(question.title).to eq "Changed title"
            expect(question.body).to eq "Changed body"
            expect(@user.subscribes).to be_empty
          end

          it "render to update template" do
            expect(response).to render_template :update
          end
        end

        context "with invalid data" do
          let(:parameters) { { id: question, format: :js, question: { title: nil } } }

          before { subject }

          it "not changed question attributes" do
            question.reload
            expect(question.title).to eq "Simple title"
            expect(question.body).to eq "Placeholder for body"
          end

          it "render update template" do
            expect(response).to render_template :update
          end
        end
      end

      context "can not edit not his question" do
        it "can not update question" do
          subject
          expect(question.title).to_not eq "Change title"
          expect(question.body).to_not eq "Change body"
        end
      end
    end

    describe "Unauthenticated user" do
      it "get 401 status Unauthorized" do
        subject
        expect(response.status).to eq 401
      end
    end
  end
end
