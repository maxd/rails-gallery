class AlbumsController < ApplicationController

  layout 'modal_dialog'

  def new
    @album = Album.new
  end

  def create
    @album = Album.new(params[:album])

    if @album.save
      head status: :created, location: [@album]
    else
      render status: :unprocessable_entity, action: :new, layout: false
    end
  end

  def edit
    @album = Album.find(params[:id])
  end

  def update
    @album = Album.find(params[:id])

    if @album.update_attributes(params[:album])
      head status: :accepted, location: [@album]
    else
      render status: :unprocessable_entity, action: :edit, layout: false
    end
  end

  def confirm_destroy
    @album = Album.find(params[:id])
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    head :no_content
  end

end
