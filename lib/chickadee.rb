require 'erb'

class Chickadee
  def initialize(target_time, en)
    @stop, @en = (target_time.to_f - Time.now.to_f), en
  end

  def time_ratio
  end

  def tempo
  end

  def mood

  end

  def tempo_playlist
    current_time = 1
    playlist_songs = []
    playlist_songs.tap do |playlist|
      until current_time >= @stop
        tempo = get_tempo(current_time)
        songs = @en.songs_in_tempo_range(tempo, tempo + 20.0)
        next if songs.empty?
        song = songs.sample
        current_time += song.audio_summary['duration']
        playlist_songs << song
      end
    end

    Playlist.new(playlist_songs)
  end

  def get_playlist
    current_time = 0
    playlist_songs = []
    playlist_songs.tap do |playlist|
      until current_time >= @stop
        #build playlist and add length of song to current time
        songs = @en.get_songs
        next if songs.empty?
        song = songs.sample
        current_time += song.audio_summary['duration']#song.duration.to_i
        playlist_songs << song
      end
    end
    Playlist.new(playlist_songs)
  end

  def build_template_manually(playlist)
    f = File.new('./lib/views/playlist.html', 'w')
    f << ERB.new(File.read('./lib/views/index.html.erb')).result(binding)
    f.close
    return f
  end

  protected

  def get_tempo(current_time)
    tempo = (current_time / @stop) * 150.0
    tempo > 60.0 ? tempo : 60.0
  end
end
