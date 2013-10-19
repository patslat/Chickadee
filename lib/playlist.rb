class Playlist
  attr_reader :songs
  def initialize(songs)
    @songs = songs
  end

  def embed_string
    "spotify:trackset:Chickadee:#{ concatenate_spotify_ids }"
  end

  protected
  def concatenate_spotify_ids
    @songs.map(&:spotify_id).join(',')
  end
end
