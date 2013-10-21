require 'erb'

class Chickadee
  def initialize(target_time, en)
    @current_time, @stop, @en = 1.0, (target_time.to_f - Time.now.to_f), en
  end

  def lively_playlist
    @current_time = 1.0
    playlist_songs = []
    playlist_songs.tap do |playlist|
      until @current_time >= @stop
        songs = @en.get_songs({
          :min_tempo => weighted_tempo,
          :max_tempo => weighted_tempo + 20,
          :min_energy => weight,
          :max_energy => weight + 0.1,
          :min_danceability => weight,
          :max_danceability => weight + 0.1
        })
        next if songs.empty?
        song = songs.sample
        @current_time += song.audio_summary['duration']
        playlist_songs << song
      end
    end

    Playlist.new(playlist_songs)
  end

  def tempo_playlist
    @current_time = 1.0
    playlist_songs = []
    playlist_songs.tap do |playlist|
      until @current_time >= @stop
        tempo = weighted_tempo
        songs = @en.songs_in_tempo_range(tempo, tempo + 20.0)
        next if songs.empty?
        song = songs.sample
        @current_time += song.audio_summary['duration']
        playlist_songs << song
      end
    end

    Playlist.new(playlist_songs)
  end

  def get_playlist
    @current_time = 1.0
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

  def weight
    weight = @current_time / @stop
    weight > 0.4 ? weight : 0.4
  end

  def weighted_tempo
    weight * 180.0
  end

end
