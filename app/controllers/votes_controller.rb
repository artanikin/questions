class VotesController < ApplicationController
  before_action :authenticate_user!

#   def up
#     vote { @vote.up }
#   end

#   def down
#     vote { @vote.down }
#   end

  def destroy
    @vote = Vote.find(params[:id])
    if current_user.author?(@vote)
      @vote.destroy
      @flash[:success] = 'Your vote remove'
    else
      @flash[:danger] = 'You can not remove not your vote'
    end
  end

  private

  # def vote
  #   @obj = vote_params[:votable_type].classify.constantize.find(vote_params[:votable_id].to_i)
  #   if current_user.author?(@obj)
  #     flash[:danger] = 'You can not vote for your question'
  #   else
  #     @vote = @obj.votes.find_or_initialize_by(author_id: current_user.id)
  #     yield
  #     flash[:success] = 'You successfully vote for question'
  #   end
  # end

#   def vote_params
#     params.require(:vote).permit(:votable_type, :votable_id)
#   end
end
