require './lib/echonest'
require 'erb'

class Chickadee
  def initialize(target_time, en)
    @target_time, @en = target_time.to_i, en
  end

  def get_playlist
    current_time = Time.now.to_i
    playlist_songs = []
    playlist_songs.tap do |playlist|
      until current_time >= @target_time
        #build playlist and add length of song to current time
        song = @en.get_songs.sample
        current_time += song.audio_summary['duration']#song.duration.to_i
        playlist_songs << song
      end
    end
    Playlist.new(playlist_songs)
  end

  def build_template(playlist)
    f = File.new('playlist.html', 'w')
    f << ERB.new(File.read('./lib/index.html.erb')).result(binding)
    f.close
    return f
  end
end

en = EchoNest.new(TOKEN)
chickadee = Chickadee.new(Time.now + 3600, en)

playlist = chickadee.get_playlist
chickadee.build_template(playlist)
