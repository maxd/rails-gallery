require 'digest'

class MediaItem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_original_filename, type: String
  field :file_type, type: Symbol
  field :file_sha256, type: String
  field :file_processing, type: Boolean

  mount_uploader :file, MediaItemUploader
  process_in_background :file

  has_and_belongs_to_many :albums
  has_many :additional_items

  index({file_sha256: 1}, unique: true)

  accepts_nested_attributes_for :additional_items

  attr_accessible :file
  attr_accessible :album_ids
  attr_accessible :additional_items_attributes

  validates_presence_of :file_original_filename
  validates_inclusion_of :file_type, in: [:image, :video]
  validates_uniqueness_of :file_sha256

  def thumb_url
    image = case file_type
      when :image then file.image_thumb
      when :video then file.video_thumb
    end
    file_processing ? image.default_url : image.url
  end

  def preview_url
    image = case file_type
      when :image then file.image_preview
      when :video then file.video_preview
    end
    file_processing ? image.default_url : image.url
  end
end
