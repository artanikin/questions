class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: User

  validates :body, presence: true
  validates :body, length: { minimum: 10 }
end
