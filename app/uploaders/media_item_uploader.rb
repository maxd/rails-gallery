# encoding: utf-8

class MediaItemUploader < ItemUploader

  include CarrierWave::MiniMagick

  version :image_preview, if: :image? do
    process :auto_orient
    process resize_to_fit: [1024, 768]
    process convert: :png

    def cache_name
      super.chomp(File.extname(super)) + '.png'
    end

    def filename
      'image_preview.png'
    end

    def full_filename(for_file)
      filename
    end
  end

  version :image_thumb, from_version: :image_preview, if: :image? do
    process resize_and_pad: [100, 75]

    def cache_name
      super.chomp(File.extname(super)) + '.png'
    end

    def filename
      'image_thumb.png'
    end

    def full_filename(for_file)
      filename
    end
  end

  version :video_preview, if: :video? do
  end

  version :video_thumb, from_version: :video_preview, if: :video? do
  end

  def filename
    'original' + File.extname(super).downcase
  end

  def extension_white_list
    FileType::DESCRIPTORS.select {|d| [:image, :video].include?(d[:type].to_sym) }.map {|d| d[:extensions] }.flatten.uniq
  end

private

  def image?(file = nil)
    model.file_type == :image
  end

  def video?(file = nil)
    model.file_type == :video
  end

  def auto_orient
    manipulate! do |img|
      img.auto_orient
      img
    end
  end

end
