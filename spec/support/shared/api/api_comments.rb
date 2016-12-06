shared_examples_for "API comments" do
  context 'comments' do
    it 'included in object' do
      expect(response.body).to have_json_size(1).at_path("#{json_root_path}/comments")
    end

    %w(id body created_at updated_at commentable_id commentable_type author_id).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("#{json_root_path}/comments/0/#{attr}")
      end
    end
  end
end
