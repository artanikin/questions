require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  describe "POST #create for question" do
    let!(:question) { create(:question) }
    let(:parameters) do
      {
        question_id: question.id,
        format: :json,
        comment: { body: "Comment Placeholder" }
      }
    end

    subject { post :create, params: parameters }

    context "Authorized user" do
      sign_in_user

      it "can add comment" do
        expect { subject }.to change(question.comments, :count).by(1)
      end

      context "with invalid data" do
        let(:parameters) do
          {
            question_id: question.id,
            format: :json,
            comment: { body: "" }
          }
        end

        it "can't add comment" do
          expect { subject }.to_not change(question.comments, :count)
        end
      end
    end

    context "Unauthorized user" do
      it "can't add comment" do
        expect { subject }.to_not change(question.comments, :count)
      end

      it "get 401 status Unauthorized" do
        expect(subject).to have_http_status(401)
      end
    end
  end

  describe "POST #create for answer" do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let(:parameters) do
      {
        answer_id: answer.id,
        format: :json,
        comment: { body: "Comment Placeholder" }
      }
    end

    subject { post :create, params: parameters }

    context "Authorized user" do
      sign_in_user

      it "can add comment" do
        expect { subject }.to change(answer.comments, :count).by(1)
      end

      context "with invalid data" do
        let(:parameters) do
          {
            answer_id: answer.id,
            format: :json,
            comment: { body: "" }
          }
        end

        it "can't add comment" do
          expect { subject }.to_not change(answer.comments, :count)
        end
      end
    end

    context "Unauthorized user" do
      it "can't add comment" do
        expect { subject }.to_not change(answer.comments, :count)
      end

      it "get 401 status Unauthorized" do
        expect(subject).to have_http_status(401)
      end
    end
  end
end
