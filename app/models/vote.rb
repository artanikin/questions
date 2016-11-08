class Vote < ApplicationRecord
  include Authorable

  belongs_to :votable, polymorphic: true

  validates :votable_type, inclusion: { in: %w(Question Answer) }
  validates :value, presence: true
  validates :value, inclusion: { in: [-1, 1] }
  validates :value, uniqueness: { scope: [:votable_type, :votable_id, :author_id] }

  def up
    update(value: 1)
  end

  def down
    update(value: -1)
  end
end
