require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'authorable'

  it { should belong_to(:commentable) }

  it { should validate_inclusion_of(:commentable_type).in_array(%w(Question Answer)) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(10) }
end
