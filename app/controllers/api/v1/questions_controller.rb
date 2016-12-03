class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question

  def index
    respond_with Question.all, includes: []
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end
end
