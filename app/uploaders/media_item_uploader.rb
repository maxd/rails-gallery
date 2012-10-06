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

  version :video_preview_mp4, if: :video? do
    process transcode: [:mp4, {video_codec: 'libx264', audio_codec: 'libfaac', custom: '-qscale 0 -preset slow -g 30 -maxrate 500k -bufsize 1000k -threads 0'}]

    def filename
      'video.mp4'
    end

    def full_filename(for_file)
      filename
    end
  end

  version :video_preview_webm, if: :video? do
    process transcode: [:webm, {video_codec: 'libvpx', audio_codec: 'libvorbis', custom: '-b 500k -ab 160000 -f webm -g 30 -maxrate 500k -bufsize 1000k -threads 0'}]

    def filename
      'video.webm'
    end

    def full_filename(for_file)
      filename
    end
  end

  version :video_thumb, if: :video? do
    process take_video_thumb: [{resolution: '100x75'}]

    def filename
      'video_thumb.png'
    end

    def full_filename(for_file)
      filename
    end
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

  def transcode(format, options = {}, transcoder_options = {})
    tmp_path = File.join(File.dirname(current_path), "video_thumb.#{Time.now.to_i}.#{format}")

    movie = FFMPEG::Movie.new(current_path)
    movie.transcode(tmp_path, options, transcoder_options)

    File.rename tmp_path, current_path
  end

  def take_video_thumb(options = {}, transcoder_options = {})
    tmp_path = File.join(File.dirname(current_path), "video_thumb.#{Time.now.to_i}.png")

    movie = FFMPEG::Movie.new(current_path)
    movie.screenshot(tmp_path, options, transcoder_options)

    File.rename tmp_path, current_path
  end

end
