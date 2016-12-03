class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question

  def index
    respond_with Question.all
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, serializer: QuestionFullSerializer
  end

  def create
    respond_with(@question = Question.create(question_params.merge(author: current_resource_owner)))
  end

  private
  def question_params
    params.require(:question).permit(:title, :body)
  end
end
