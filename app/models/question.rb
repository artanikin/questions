class Question < ApplicationRecord
  include Attachable
  include Authorable

  has_many :answers, -> { order('best desc') }, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }

  scope :with_rating, -> do
    left_joins(:votes)
      .select('questions.*, COALESCE(SUM(votes.value), 0) AS rating')
      .group('questions.id, votes.votable_type, votes.votable_id')
  end

  def evaluation
    votes.sum(:value)
  end

  def vote_up(user)
    if !user.author?(self) && votes.create(author: user, value: 1)
      true
    else
      false
    end
  end
end
