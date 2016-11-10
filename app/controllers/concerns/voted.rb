module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  private

  def vote(value)
    vote = @votable.votes.find_or_initialize_by(author_id: current_user.id)

    if vote.persisted? && vote.value == value
      vote.destroy
      render_vote_json_with_message(@votable, "You unvoted for #{param_name(@votable)}")
    else
      vote.value = value

      if vote.save
        render_vote_json_with_message(@votable, "You voted for #{param_name(@votable)}")
      else
        render json: { error: vote.errors.messages.values }, status: :unprocessable_entity
      end
    end
  end

  def render_vote_json_with_message(item, message)
    render json: { rating: item.evaluation, message: message }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def param_name(item)
    item.class.name.underscore
  end
end
