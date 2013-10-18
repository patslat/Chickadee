require 'rspec'
require './spec/spec_helper.rb'
require './lib/echonest.rb'
require './config/config.rb'

describe 'EchoNest' do
  subject(:en) { EchoNest.new(TOKEN) }
  describe 'initialize' do
    it 'should take an api key and return an object' do
      expect(en.class).to be(EchoNest)
    end
  end

  describe '#get_songs' do
    it 'returns an array' do
      expect(en.get_songs.class).to be(Array)
    end

    it 'returns an array of songs' do
      expect(en.get_songs.first.class).to be(Song)
    end

  end
end
