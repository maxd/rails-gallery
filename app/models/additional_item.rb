class AdditionalItem
  include Mongoid::Document

  field :file_original_filename, type: String
  field :file_type, type: Symbol

  mount_uploader :file, AdditionalItemUploader

  belongs_to :media_item

  attr_accessible :file

  validates_presence_of :file_original_filename

  set_callback :validation, :before do |mi|
    mi.file_original_filename = mi.file.file.original_filename
    mi.file_type = FileType.file_type(mi.file.file.original_filename)
  end
end