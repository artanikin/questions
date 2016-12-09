require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  it_behaves_like 'Authorable'
  it { should belong_to(:question) }
  it { should validate_uniqueness_of(:question_id).scoped_to(:author_id) }
end
