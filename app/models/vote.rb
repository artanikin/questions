class Vote < ApplicationRecord
  include Authorable

  belongs_to :votable, polymorphic: true

  validates :votable_type, inclusion: { in: %w(Question Answer) }
  validates :value, presence: true
  validates :value, inclusion: { in: [-1, 1] }
  validates :value, presence: true, inclusion: { in: [-1, 1] }
  validates :author_id,
    uniqueness: { scope: [:votable_type, :votable_id], message: 'You have already voted' },
    not_votable_author: true
end
