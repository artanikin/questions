class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, except: [:create]

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
    if current_user.author?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully removed'
    else
      flash[:alert] = 'Answer does not removed. You are not the author of this answer'
    end
  end

  def update
    if current_user.author?(@answer)
      if @answer.update(answer_params)
        flash.now[:notice] = 'Your answer successfully updated'
      else
        flash.now[:alert] = 'Your answer not updated'
      end
    else
      flash.now[:alert] = 'Answer does not updated. You are not the author of this answer'
    end
  end

  def best
    @answer.mark_as_best
    flash.now[:notice] = 'Answer mark as Best'
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
