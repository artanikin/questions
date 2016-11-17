class Comment < ApplicationRecord
  include Authorable

  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
  validates :body, length: { minimum: 10 }
  validates :commentable_type, inclusion: { in: %w(Question Answer) }
end
