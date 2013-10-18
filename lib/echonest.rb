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

  def get_songs(params = {})
    uri = URI.parse(base_uri + 'song/' + 'search')
    res = make_api_call(uri, params)

    return res.value unless res.is_a? Net::HTTPSuccess
    song_data = JSON.parse(res.body)['response']['songs']
    song_data.map do |song_datum|
      Song.new(song_datum)
    end
  end


  protected

  def make_api_call(uri, params = {})
    params.merge! default_params
    uri.query = URI.encode_www_form(params)
    Net::HTTP.get_response uri
  end

  def default_params
    {
      :api_key => @key
    }
  end
end

class Song
  attr_reader :artist_id, :id, :artist_name, :title
  def initialize(params)
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
end

en = EchoNest.new(TOKEN)
p en.get_songs
