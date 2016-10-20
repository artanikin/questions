module ControllerHelper
  def answer_params(question)
    answer = question.answers.first
    @parameters = { question_id: question, id: answer }
  end
end
