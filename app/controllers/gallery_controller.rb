class GalleryController < ApplicationController

  layout 'gallery'

  def index
    @albums = Album.all
  end

end
