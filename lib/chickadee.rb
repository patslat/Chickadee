require 'echonest'

class Chickadee
  def initialize(target_time, en)
    @target_time, @en = target_time.to_i, en
  end

  def get_playlist
    current_time = Time.now.to_i
    [].tap do |playlist|
      until current_time >= @target_time
        #build playlist and add length of song to current time
        song = @en.get_songs.sample
        current_time += song.length.to_i
        playlist << song
      end
    end
  end
end
