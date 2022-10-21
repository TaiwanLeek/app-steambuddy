# frozen_string_literal: true

require_relative '../lib/steam_api'
require_relative 'spec_helper'

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
      _(owned_games.count).must_equal CORRECT['owned']['response']['game_count']
    end
    it 'should provide correct owned game list' do
      owned_games = SteamCircle::SteamApi.new(STEAM_KEY)
                                         .owned_games(STEAM_ID)
      _(owned_games.games).must_equal CORRECT['owned']['response']['games']
    end
  end
end
