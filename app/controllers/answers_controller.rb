class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(author: current_user))

    if @answer.save
      flash.now[:notice] = 'Your answer successfully created.'
    else
      flash.now[:alert] = 'Your answer not created. Check the correctness of filling the fields.'
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    if current_user.author?(answer)
      answer.destroy
      flash[:notice] = 'Your answer successfully removed'
    else
      flash[:alert] = 'Answer does not removed. You are not the author of this answer'
    end
    redirect_to answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
