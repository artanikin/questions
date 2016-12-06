shared_examples_for 'Authorable' do
  it { should belong_to(:author) }
end
