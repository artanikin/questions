class VotesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @vote = Vote.find(params[:id])
    if current_user.author?(@vote)
      @vote.destroy
      @flash[:success] = 'Your vote remove'
    else
      @flash[:danger] = 'You can not remove not your vote'
    end
  end
end
