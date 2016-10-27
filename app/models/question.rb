class Question < ApplicationRecord
  belongs_to :author, class_name: User
  has_many :answers, -> { order('best desc') }, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }
end
