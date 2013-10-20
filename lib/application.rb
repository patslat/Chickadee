require './lib/echonest'
require './lib/playlist'
require './lib/song'
require './lib/chickadee'
require 'sinatra'

get '/' do
  en = EchoNest.new(TOKEN)
  chickadee = Chickadee.new(Time.now + 3000, en)

  playlist = chickadee.get_playlist
  erb :index, :locals => { :playlist => playlist }
end

get '/tempo' do
  en = EchoNest.new(TOKEN)
  chickadee = Chickadee.new(Time.now + 3000, en)

  playlist = chickadee.tempo_playlist
  erb :index, :locals => { :playlist => playlist }
end
