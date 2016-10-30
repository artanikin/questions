class Question < ApplicationRecord
  belongs_to :author, class_name: User
  has_many :answers, -> { order('best desc') }, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
