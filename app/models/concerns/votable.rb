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
end
