require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author) }
  it { should have_many(:attachments) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_least(10) }
  it { should validate_length_of(:body).is_at_least(10) }

  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }
end
