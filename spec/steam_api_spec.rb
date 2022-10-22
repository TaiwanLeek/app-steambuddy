# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/steam_api'

describe 'Tests Steam API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<STEAM_ID>') { STEAM_ID }
    c.filter_sensitive_data('<STEAM_KEY>') { STEAM_KEY }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Friends information' do
    it 'should provide correct friend list' do
      friends = SteamCircle::SteamApi.new(STEAM_KEY)
                                     .friends(STEAM_ID)
      _(friends.list).must_equal CORRECT['friends']
    end
  end

  describe 'Owned games information' do
    it 'should provide correct game count' do
      owned_games = SteamCircle::SteamApi.new(STEAM_KEY)
                                         .owned_games(STEAM_ID)
      correct_game_count = CORRECT['owned']['response']['game_count']
      if correct_game_count
        _(owned_games.count).must_equal correct_game_count
      else
        assert_nil owned_games.count
      end
    end

    it 'should provide correct owned game list' do
      owned_games = SteamCircle::SteamApi.new(STEAM_KEY)
                                         .owned_games(STEAM_ID)
      correct_games = CORRECT['owned']['response']['games']
      if correct_games
        _(owned_games.games).must_equal correct_games
      else
        assert_nil owned_games.games
      end
    end
  end
end
