class SubscribesController < ApplicationController
  before_action :set_question, only: [:create]
  before_action :set_subscribe, only: [:destroy]

  authorize_resource

  respond_to :js

  def create
    respond_with(@subscribe = @current_user.subscribes.create(question: @question))
  end

  def destroy
    respond_with(@subscribe.destroy)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_subscribe
    @subscribe = Subscribe.find(params[:id])
  end
end
