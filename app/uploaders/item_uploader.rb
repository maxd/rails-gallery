# encoding: utf-8

class ItemUploader < CarrierWave::Uploader::Base

  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include CarrierWave::Backgrounder::Delay

  before :cache, :fill_metadata_fields

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    asset_path("item/" + [version_name, "default.png"].compact.join('_'))
  end

private

  def fill_metadata_fields(file)
    if version_name.nil? && model.new_record?
      model.file_original_filename = file.file.original_filename
      model.file_type = FileType.file_type(file.file.original_filename)
      model.file_sha256 = Digest::SHA256.file(file.to_file).hexdigest if model.respond_to? :file_sha256
    end
  end

end
