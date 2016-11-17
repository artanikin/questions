shared_examples_for 'authorable' do
  it { should belong_to(:author) }
end
