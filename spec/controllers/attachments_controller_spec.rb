require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE #destroy' do
    describe 'Authorized user' do
      sign_in_user

      it 'can delete his attachment' do
        question.update(author: @user)
        expect { delete :destroy, format: :js, params: { id: attachment } }
          .to change(question.attachments, :count).by(-1)
      end

      it 'can not delete his attachment' do
        expect { delete :destroy, format: :js, params: { id: attachment } }
          .to_not change(question.attachments, :count)
      end
    end

    describe 'Unauthorized user' do
      it 'can not delete attachment' do
        expect { delete :destroy, format: :js, params: { id: attachment } }
          .to_not change(question.attachments, :count)
      end

      it 'redirect to log in' do
        delete :destroy, params: { id: attachment, format: :js }
        expect(response.status).to eq 401
      end
    end
  end
end
