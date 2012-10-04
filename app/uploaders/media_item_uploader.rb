# encoding: utf-8

class MediaItemUploader < ItemUploader

  include CarrierWave::MiniMagick

  def extension_white_list
    FileType::DESCRIPTORS.select {|d| [:image, :video].include?(d[:type].to_sym) }.map {|d| d[:extensions] }.flatten.uniq
  end

end
