require './lib/echonest'
require './lib/playlist'
require './lib/song'
require './lib/chickadee'

en = EchoNest.new(TOKEN)
chickadee = Chickadee.new(Time.now + 360, en)

playlist = chickadee.get_playlist
chickadee.build_template(playlist)
