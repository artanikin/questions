shared_examples_for 'Attachable' do
  it { should have_many(:attachments) }

  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }
end
