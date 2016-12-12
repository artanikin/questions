class SubscribesController < ApplicationController
  before_action :set_question, only: [:create]

  authorize_resource

  respond_to :js

  def create
    @subscribe = @current_user.subscribes.build(question_id: @question.id)
    if @subscribe.save
      flash.now[:notice] = "You successfully subscribe to question"
    else
      flash.now[:alert] = "You can not subscribe to question"
    end
  end

  def destroy
    @subscribe = Subscribe.find(params[:id])
    @question = @subscribe.question

    if @current_user.author?(@subscribe)
      @subscribe.destroy
      flash.now[:notice] = "You successfully unsubscribe to question"
    else
      flash.now[:alert] = "You can not unsubscribe to question"
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
