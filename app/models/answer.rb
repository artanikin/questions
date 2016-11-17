class Answer < ApplicationRecord
  include Attachable
  include Authorable
  include Votable
  include Commentable

  belongs_to :question

  validates :body, presence: true
  validates :body, length: { minimum: 10 }
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def mark_as_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
