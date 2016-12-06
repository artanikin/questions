require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  describe "POST #create for question" do
    let!(:object) { create(:question) }

    it_behaves_like "Add comments"
  end

  describe "POST #create for answer" do
    let!(:question) { create(:question) }
    let!(:object) { create(:answer, question: question) }

    it_behaves_like "Add comments"
  end
end
