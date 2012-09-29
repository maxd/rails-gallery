class ItemsController < ApplicationController

  before_filter :init_scope

  def index
    @items = @items_scope.all

    render layout: false
  end

private

  def init_scope
    if params[:album_id].present?
      @items_scope = Album.find(params[:album_id]).items
    else
      @items_scope = Item
    end
  end

end
