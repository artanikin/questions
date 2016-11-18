class Question < ApplicationRecord
  include Attachable
  include Authorable
  include Votable
  include Commentable

  has_many :answers, -> { order('best desc') }, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }
end
