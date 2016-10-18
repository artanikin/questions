class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def create
    @answer = @question.answers.new(answer_params.merge(author: current_user))
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    answer = @question.answers.find(params[:id])
    if current_user.author?(answer)
      answer.destroy
      flash[:notice] = 'Your answer successfully removed'
    end
    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
