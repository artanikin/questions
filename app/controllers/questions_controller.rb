class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:notice] = 'Your question successfully created'
      redirect_to @question
    else
      flash[:alert] = 'Your question not created. Check the correctness of filling the fields.'
      render :new
    end
  end

  def update
    if current_user.author?(@question)
      if @question.update(question_params)
        flash.now[:notice] = 'Your question successfully updated'
      else
        flash.now[:alert] = 'Your question not updated'
      end
    else
      flash.now[:alert] = 'Question does not updated. You are not the author of this question'
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      flash[:notice] = 'Your question successfully removed'
    else
      flash[:alert] = 'Question does not removed. You are not the author of this question'
    end
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
