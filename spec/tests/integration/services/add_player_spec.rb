# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'

describe 'Integration test of AddPlayer service and API gateway' do
  it 'must add a legitimate player' do
    # WHEN we request to add a player
    id_request = SteamBuddy::Forms::NewPlayer.new.call(remote_id: STEAM_ID)
    id_checkpoint = SteamBuddy::Service::AddPlayerCheck.new.call(id_request)
    res = SteamBuddy::Service::AddPlayer.new.call(id_checkpoint.value!)

    # THEN we should see a single player in the list
    _(res.success?).must_equal true
    player = res.value!
    _(player.username).must_equal USERNAME
  end
end
