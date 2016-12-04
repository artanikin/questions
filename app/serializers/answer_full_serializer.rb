class AnswerFullSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :author_id, :question_id

  has_many :comments
  has_many :attachments
end
