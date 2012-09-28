class GalleryController < ApplicationController

  layout 'gallery'

  def index
    @albums = Album.all
  end

  def albums
    @albums = Album.all

    render layout: false
  end

end
