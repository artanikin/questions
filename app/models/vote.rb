class Vote < ApplicationRecord
  include Authorable

  belongs_to :votable, polymorphic: true

  validates :votable_type, inclusion: { in: %w(Question Answer) }
  validates :value, inclusion: { in: [-1, 1] }
  validates :author_id,
    uniqueness: { scope: [:votable_type, :votable_id], message: 'You have already voted' },
    not_votable_author: true

  def need_unvote?(value)
    persisted? && self.value == value
  end
end
