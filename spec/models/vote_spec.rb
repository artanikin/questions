require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :author }

  it { should validate_inclusion_of(:votable_type).in_array(%w(Question Answer)) }
  it { should validate_inclusion_of(:value).in_array([-1,1]) }
  it { should validate_uniqueness_of(:value).scoped_to(:votable_type, :votable_id, :author_id) }
end
