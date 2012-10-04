# encoding: utf-8

class ItemUploader < CarrierWave::Uploader::Base

  include Sprockets::Helpers::RailsHelper

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  end

end
