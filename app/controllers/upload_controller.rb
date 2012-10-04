class UploadController < ApplicationController

  layout false

  def uploader
    @album_id = params[:album_id]
  end

  def upload
    media_item = MediaItem.new(params[:upload])
    if media_item.save
      render status: :created, json: { message: 'Successfully uploaded' }
    else
      render status: :unprocessable_entity, json: { message: media_item.errors.values.flatten.first }
    end
  end

end