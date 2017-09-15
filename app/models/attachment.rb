class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true
  validates :file, presence: true
  
  mount_uploader :file, FileUploader

  def filename
    self.file.identifier
  end
end
