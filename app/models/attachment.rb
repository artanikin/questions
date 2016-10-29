class Attachment < ApplicationRecord
  mount_uploader :file, FileUploader

  belongs_to :attachable, polymorphic: true
end
