shared_examples "Add comments" do
  let(:parameters) do
    {
      "#{object.class.name.downcase}_id".to_sym => object.id,
      format: :json,
      comment: { body: "Comment Placeholder" }
    }
  end

  subject { post :create, params: parameters }

  context "Authorized user" do
    sign_in_user

    it "can add comment" do
      expect { subject }.to change(object.comments, :count).by(1)
    end

    context "with invalid data" do
      let(:parameters) do
        {
          "#{object.class.name.downcase}_id".to_sym => object.id,
          format: :json,
          comment: { body: "" }
        }
      end

      it "can't add comment" do
        expect { subject }.to_not change(object.comments, :count)
      end
    end
  end

  context "Unauthorized user" do
    it "can't add comment" do
      expect { subject }.to_not change(object.comments, :count)
    end

    it "get 401 status Unauthorized" do
      expect(subject).to have_http_status(401)
    end
  end
end
