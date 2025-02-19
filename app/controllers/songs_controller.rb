class SongsController < ApplicationController
  def index

    if !params[:artist_id]
      @songs = Song.all
    else
      @artist = Artist.find_by_id params[:artist_id]
      if !@artist
        flash[:alert] = "Artist not found"
        redirect_to artists_path
      else
        @songs = @artist.songs
      end
    end

  end

  def show
    if !params[:artist_id]
      @song = Song.find(params[:id])
    else
      @artist = Artist.find_by_id params[:artist_id]
      if @artist
        @song = @artist.songs.find_by_id params[:id]
        if !@song
          flash[:alert] = "Song not found"
          redirect_to artist_songs_path @artist
        end
      else
        flash[:alert] = "Artist not found"
        redirect_to artists_path
      end
    end

  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end

  def all_songs_if_no_artist_id
      @songs = Song.all if !params[:artist_id]
  end

end
