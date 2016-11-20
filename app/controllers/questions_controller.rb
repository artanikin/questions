class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :build_answer, only: [:show]

  after_action :publish_question, only: [:create]

  respond_to :js

  include Voted

  def index
    respond_with(@questions = Question.with_rating)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(question_params.merge(author: current_user)))
  end

  def update
    @question.update(question_params) if current_user.author?(@question)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy) if current_user.author?(@question)
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(json: { question: @question })
    )
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
