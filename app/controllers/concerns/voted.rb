module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    authorize! :vote_up, @votable
    has_errors, messages = @votable.vote_up(current_user)
    render_vote_json(has_errors, messages)
  end

  def vote_down
    authorize! :vote_down, @votable
    has_errors, messages = @votable.vote_down(current_user)
    render_vote_json(has_errors, messages)
  end

  private

  def render_vote_json(has_errors, messages)
    if has_errors
      render json: { error: messages }, status: :unprocessable_entity
    else
      render json: { rating: @votable.evaluation, message: messages }
    end
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
