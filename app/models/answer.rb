class Answer < ApplicationRecord
  belongs_to :question

  validates :body, :question_id, presence: true
  validates :question_id, numericality: { only_integer: true, greater_than: 0 }
  validates :body, length: { minimum: 10 }
end
