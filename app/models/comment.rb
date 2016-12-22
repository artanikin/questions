class Comment < ApplicationRecord
  include Authorable

  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true
  validates :body, length: { minimum: 10 }
  validates :commentable_type, inclusion: { in: %w(Question Answer) }

  default_scope -> { order("created_at ASC") }
end
