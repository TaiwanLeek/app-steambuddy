# frozen_string_literal: true

require_relative '../lib/steam_api'
require_relative 'spec_helper'

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
