class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.with_rating
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
      flash[:success] = 'Your question successfully created'
      redirect_to @question
    else
      flash[:danger] = 'Your question not created. Check the correctness of filling the fields.'
      render :new
    end
  end

  def update
    if current_user.author?(@question)
      if @question.update(question_params)
        flash.now[:success] = 'Your question successfully updated'
      else
        flash.now[:danger] = 'Your question not updated'
      end
    else
      flash.now[:danger] = 'Question does not updated. You are not the author of this question'
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      flash[:success] = 'Your question successfully removed'
    else
      flash[:alert] = 'Question does not removed. You are not the author of this question'
    end
    redirect_to questions_path
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  private

  def vote(value)
    @question = Question.find(params[:id])

    respond_to do |format|
      @vote = @question.votes.find_or_initialize_by(author_id: current_user.id)

      if @vote.persisted? && @vote.value == value
        @vote.destroy
        message = 'You unvoted for question'
        format.json { render json: { rating: @question.evaluation, message: message } }
      else
        @vote.value = value

        if @vote.save
          message = 'You voted for question'
          format.json { render json: { rating: @question.evaluation, message: message } }
        else
          format.json do
            render json: { error: @vote.errors.messages.values }, status: :unprocessable_entity
          end
        end
      end
    end
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
