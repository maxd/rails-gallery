class AdditionalItem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_original_filename, type: String
  field :file_type, type: Symbol
  field :file_processing, type: Boolean

  mount_uploader :file, AdditionalItemUploader
  process_in_background :file

  belongs_to :media_item

  index({media_item: 1})

  attr_accessible :file

  validates_presence_of :file_original_filename
end