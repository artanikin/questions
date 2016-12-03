class AttachmentSerializer < ActiveModel::Serializer
  attribute :url do
    object.file.url
  end
end
