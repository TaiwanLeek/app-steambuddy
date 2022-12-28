# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'

describe 'Integration test of ListPlayers service and API gateway' do
  it 'must return a list of players' do
    # GIVEN a player is in the database
    SteamBuddy::Gateway::Api.new(SteamBuddy::App.config)
      .add_player(STEAM_ID)

    # WHEN we request a list of players
    list = [[STEAM_ID]]
    res = SteamBuddy::Service::ListPlayers.new.call(list)

    # THEN we should see a single project in the list
    _(res.success?).must_equal true
    list = res.value!
    _(list.players.count).must_equal 1
    _(list.players.first.username).must_equal USERNAME
  end

  it 'must return and empty list if we specify none' do
    # WHEN we request a list of players
    list = []
    res = SteamBuddy::Service::ListPlayers.new.call(list)

    # THEN we should see a no projects in the list
    _(res.success?).must_equal true
    list = res.value!
    _(list.players.count).must_equal 0
  end
end
