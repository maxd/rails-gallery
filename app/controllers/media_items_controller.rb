class MediaItemsController < ApplicationController

  before_filter :init_scope

  def index
    @media_items = @media_items_scope.all

    render layout: false
  end

private

  def init_scope
    if params[:album_id].present?
      @media_items_scope = Album.find(params[:album_id]).media_items
    else
      @media_items_scope = MediaItem
    end
  end

end
