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

  def songs_in_tempo_range(min, max)
    p min
    p max
    get_songs({
      :min_tempo => "#{min}",
      :max_tempo => "#{max}"
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
      :max_duration => '360',
      :song_type => ['studio:true', 'live:false'],
      :style => ['-country', 'indie']
    }
  end
end
