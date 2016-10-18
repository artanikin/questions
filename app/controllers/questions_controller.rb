class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:notice] = 'Your question successfully created'
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      flash[:notice] = 'Your question successfully removed'
    end
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
