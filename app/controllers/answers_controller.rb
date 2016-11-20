class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, except: [:create]
  before_action :set_question, only: [:create]

  after_action :publish_answer, only: [:create]

  respond_to :js

  include Voted

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(author: current_user)))
  end

  def destroy
    respond_with(@answer.destroy) if current_user.author?(@answer)
  end

  def update
    @answer.update(answer_params) if current_user.author?(@answer)
    respond_with(@answer)
  end

  def best
    @answer.mark_as_best
    respond_with(@answer)
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "answers_#{@question.id}",
      ApplicationController.render(json: {
        answer: @answer,
        attachments: @answer.attachments
      })
    )
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
