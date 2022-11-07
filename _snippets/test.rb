# frozen_string_literal: true

require_relative '../require_app'
require_app

require_relative '../spec/helpers/test_config_helper'

player = SteamBuddy::Steam::PlayerMapper
    .new(STEAM_KEY)
    .find(STEAM_ID)

# Add player to database
SteamBuddy::Repository::For.entity(player).create(player)

puts 'Test end.'
