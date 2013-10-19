require 'net/http'
require 'json'
require './config/config.rb'

class EchoNest
  def initialize(key)
    @key = key
  end

  def base_uri
    "http://developer.echonest.com/api/v4/"
  end

  def songs_in_tempo_range(n, min, max)
    get_songs({
      :limit => n,
      :min_tempo => min,
      :max_tempo => max
    })
  end

  def get_songs(params = {})
    uri = URI.parse(base_uri + 'song/' + 'search')
    res = make_api_call(uri, params)

    return res.value unless res.is_a? Net::HTTPSuccess
    song_data = JSON.parse(res.body)['response']['songs']
    Song.parse_available(song_data)
  end



  protected

  def make_api_call(uri, params = {})
    params.merge! default_params
    uri.query = URI.encode_www_form(params)
    Net::HTTP.get_response uri
  end

  def default_params
    {
      :api_key => @key,
      :bucket => ['id:spotify-WW', 'audio_summary', 'tracks'],
      :artist => ['lorde', 'green day', 'linkin park', 'weezer'].sample
    }
  end
end

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
