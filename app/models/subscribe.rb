class Subscribe < ApplicationRecord
  include Authorable

  belongs_to :question

  validates :question_id, uniqueness: { scope: :author_id }
end
