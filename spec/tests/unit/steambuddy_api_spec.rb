# frozen_string_literal: true

require_relative '../../helpers/spec_helper'

describe 'Unit test of SteamBuddy API gateway' do
  it 'must report alive status' do
    alive = SteamBuddy::Gateway::Api.new(SteamBuddy::App.config).alive?
    _(alive).must_equal true
  end

  it 'must be able to add a player' do
    res = SteamBuddy::Gateway::Api.new(SteamBuddy::App.config)
      .add_player(STEAM_ID)

    _(res.success?).must_equal true
    _(res.parse.keys.count).must_be :>=, 5
  end

  it 'must return a list of player' do
    # GIVEN a player is in the database
    SteamBuddy::Gateway::Api.new(SteamBuddy::App.config)
      .add_player(STEAM_ID)

    # WHEN we request a list of players
    list = [[STEAM_ID]]
    res = SteamBuddy::Gateway::Api.new(SteamBuddy::App.config)
      .players_list(list)

    # THEN we should see a single project in the list
    _(res.success?).must_equal true
    data = res.parse
    _(data.keys).must_include 'players'
    _(data['players'].count).must_equal 1
    _(data['players'].first.keys.count).must_be :>=, 5
  end
end
