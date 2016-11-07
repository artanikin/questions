class Question < ApplicationRecord
  include Attachable
  include Authorable

  has_many :answers, -> { order('best desc') }, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }
end
