class AlbumsController < ApplicationController
  def index
    @albums = Album.all
    render :index
  end

  def show
    @album = Album.find(params[:id])
    render :show
  end

  def create
    @album = Album.new(params[:album])

    if @album.save
      render :show
    else
      render json: @album.errors
    end
  end
end
