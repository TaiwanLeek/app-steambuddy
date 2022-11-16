# frozen_string_literal: true

require_relative '../require_app'
require_app

require_relative '../spec/helpers/test_config_helper'

player = SteamBuddy::Steam::PlayerMapper.new(STEAM_KEY).find("76561198326876707")

# SteamBuddy::Repository::For.entity(player).create(player)

players = SteamBuddy::Repository::For.klass(SteamBuddy::Entity::Player).all

puts 'Test end.'
