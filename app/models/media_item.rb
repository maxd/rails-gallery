require 'digest'

class MediaItem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_original_filename, type: String
  field :file_type, type: Symbol
  field :file_sha256, type: String

  mount_uploader :file, MediaItemUploader

  has_and_belongs_to_many :albums
  has_many :additional_items

  accepts_nested_attributes_for :additional_items

  attr_accessible :file
  attr_accessible :album_ids
  attr_accessible :additional_items_attributes

  validates_presence_of :file_original_filename
  validates_inclusion_of :file_type, in: [:image, :video]
  validates_uniqueness_of :file_sha256

  set_callback :validation, :before do |mi|
    if mi.new_record?
      mi.file_original_filename = mi.file.file.original_filename
      mi.file_type = FileType.file_type(mi.file.file.original_filename)
      mi.file_sha256 = Digest::SHA256.file(mi.file.file.to_file).hexdigest
    end
  end
end
