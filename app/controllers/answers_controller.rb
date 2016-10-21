class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def destroy
    answer = Answer.find(params[:id])
    question = answer.question
    if current_user.author?(answer)
      answer.destroy
      flash[:notice] = 'Your answer successfully removed'
    else
      flash[:alert] = 'Answer does not removed. You are not the author of this answer'
    end
    redirect_to question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
