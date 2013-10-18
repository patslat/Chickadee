require 'rspec'
require './lib/chickadee.rb'

describe 'Chickadee' do
  let(:en) { double 'en' }
  subject(:chickadee) { Chickadee.new(Time.now + (60 * 60), en) }
  it 'initializs with a target time and an ecnonest instance' do
    expect(chickadee.class).to be Chickadee
  end

  describe '#get_playlist' do
    let(:song) { double 'song' }

    before :each do
      song.stub(:length) { 180 }
      song.stub(:class) { Song }
      en.stub(:get_songs) { [song, song] }
    end
    it 'returns an array' do
      expect(chickadee.get_playlist.class).to be(Array)
    end

    it 'asks EchoNest for songs at least once' do
      en.should_receive(:get_songs).at_least :once
      chickadee.get_playlist
    end

    it 'returns an array of songs' do
      playlist = chickadee.get_playlist
      classes = playlist.map(&:class).uniq
      expect(playlist.map(&:class).uniq.length).to be 1
      expect(classes.first).to be Song
  end
    end
end
