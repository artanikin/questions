class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true, optional: true

  mount_uploader :file, FileUploader
end
