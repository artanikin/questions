class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer

  def index
    question = Question.find(params[:question_id])
    respond_with question.answers.reorder('id')
  end
end
