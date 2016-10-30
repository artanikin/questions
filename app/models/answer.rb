class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: User
  has_many :attachments, as: :attachable

  validates :body, presence: true
  validates :body, length: { minimum: 10 }
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def mark_as_best
    transaction do
      self.question.answers.where(best: true).update_all(best: false)
      self.update!(best: true)
    end
  end
end
