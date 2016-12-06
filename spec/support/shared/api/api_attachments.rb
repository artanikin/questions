shared_examples_for "API attachments" do
  context 'attachments' do
    it 'included in object' do
      expect(response.body).to have_json_size(1).at_path("#{json_root_path}/attachments")
    end

    it "contains #{attr}" do
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{json_root_path}/attachments/0/url")
    end
  end
end
