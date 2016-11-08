class VotesController < ApplicationController
  def up
    @vote = Vote.find_or_create_by(vote_params.merge(author_id: current_user.id))
    @vote.update(value: 1)
  end

  private

  def vote_params
    params.require(:vote).permit(:votable_type, :votable_id)
  end
end
