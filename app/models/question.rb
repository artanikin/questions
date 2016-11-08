class Question < ApplicationRecord
  include Attachable
  include Authorable

  has_many :answers, -> { order('best desc') }, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }

  scope :with_raiting, -> do
    left_joins(:votes)
      .select('questions.*, COALESCE(SUM(votes.value), 0) AS raiting')
      .group('questions.id, votes.votable_type, votes.votable_id')
      .order('raiting DESC')
  end

  def vote_up(user)
    votes.create(author: user, value: 1)
  end
end
