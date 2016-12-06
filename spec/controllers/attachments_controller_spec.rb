require "rails_helper"

RSpec.describe AttachmentsController, type: :controller do
  describe "DELETE #destroy for question" do
    let!(:object) { create(:question) }
    let!(:attachment) { create(:attachment, attachable: object) }

    it_behaves_like "Delete attachments"

    subject { delete :destroy, format: :js, params: { id: attachment } }
  end

  describe "DELETE #destroy for answer" do
    let!(:question) { create(:question) }
    let!(:object) { create(:answer) }
    let!(:attachment) { create(:attachment, attachable: object) }

    it_behaves_like "Delete attachments"
  end
end
