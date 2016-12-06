shared_examples "Delete attachments" do
  subject { delete :destroy, format: :js, params: { id: attachment } }

  describe "Authorized user" do
    sign_in_user

    it "can delete his attachment" do
      object.update(author: @user)
      expect { subject }.to change(object.attachments, :count).by(-1)
    end

    it "can not delete attachment for not his object" do
      expect { subject }.to_not change(object.attachments, :count)
    end
  end

  describe "Unauthorized user" do
    it 'can not delete attachment' do
      expect { subject }.to_not change(object.attachments, :count)
    end

    it "redirect to log in" do
      subject
      expect(response.status).to eq 401
    end
  end
end
