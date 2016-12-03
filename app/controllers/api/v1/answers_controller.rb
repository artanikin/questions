class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer

  def index
    question = Question.find(params[:question_id])
    respond_with question.answers.reorder('id')
  end

  def show
    answer = Answer.find(params[:id])
    respond_with answer, serializer: AnswerFullSerializer
  end

  def create
    question = Question.find(params[:question_id])
    respond_with(@answer = question.answers.create(answer_params.merge(author: current_resource_owner)))
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
