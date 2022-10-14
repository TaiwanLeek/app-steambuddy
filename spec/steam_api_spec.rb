# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/steam_api'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
STEAM_KEY = CONFIG['key']
STEAM_ID = CONFIG['steamid']
CORRECT = YAML.safe_load(File.read('spec/fixtures/steam_results.yml'))

describe 'Tests Steam API library' do
  describe 'Friends information' do
    it 'should provide correct friend list' do
      friends = SteamCircle::SteamApi.new(STEAM_KEY)
                                     .friends(STEAM_ID)
      _(friends.list).must_equal CORRECT['friends']
    end
  end

  describe 'Owned games information' do
    it 'should provide correct owned game list' do
      owned_games = SteamCircle::SteamApi.new(STEAM_KEY)
                                         .owned_games(STEAM_ID)
      _(owned_games.count).must_equal CORRECT['owned']['response']['game_count']
      _(owned_games.games).must_equal CORRECT['owned']['response']['games']
    end
  end
end
