class Song
  attr_reader :artist_id, :id, :artist_name, :title, :spotify_id, :track, :audio_summary
  def initialize(params)
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def self.parse_available(songs)
    songs.select! { |song| song['tracks'].first }
    songs.map do |song|
      song['artist_foreign_ids'] = song['artist_foreign_ids'].first
      song['track'] = song['tracks'].first
      song['spotify_id'] = song['track']['foreign_id'].gsub('spotify-WW:track:', '')
      Song.new(song)
    end
  end
end
