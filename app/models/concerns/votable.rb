module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    scope :with_rating, -> do
      left_joins(:votes)
        .select("#{table_name}.*, COALESCE(SUM(votes.value), 0) AS rating")
        .group("#{table_name}.id, votes.votable_type, votes.votable_id")
        .order('created_at ASC')
    end
  end

  def evaluation
    votes.sum(:value)
  end

  def vote_up(user)
    vote(user, 1)
  end

  def vote_down(user)
    vote(user, -1)
  end

  private

  def vote(user, value)
    vote = votes.find_or_initialize_by(author_id: user.id)

    if vote.need_unvote?(value)
      vote.destroy
      messages = "You unvoted for #{self.class.name.underscore}"
    else
      vote.value = value

      if vote.save
        messages = "You voted for #{self.class.name.underscore}"
      else
        has_errors = true
        messages = vote.errors.messages.values
      end
    end

    [ has_errors, messages ]
  end
end
