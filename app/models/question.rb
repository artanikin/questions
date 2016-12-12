class Question < ApplicationRecord
  include Attachable
  include Authorable
  include Votable
  include Commentable

  has_many :answers, -> { order('best desc') }, dependent: :destroy
  has_many :subscribes, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }

  after_create :subscribe_author

  private

  def subscribe_author
    self.subscribes.create(author_id: self.author_id)
  end
end
