# frozen_string_literal: true

=begin
require_relative '../require_app'
require_app

require_relative '../spec/helpers/test_config_helper'

player = SteamBuddy::Steam::PlayerMapper.new(STEAM_KEY).find("76561198326876707")

# SteamBuddy::Repository::For.entity(player).create(player)

players = SteamBuddy::Repository::For.klass(SteamBuddy::Entity::Player).all
=end


a = [5, 3, 7, 6, 15]
a&.sort do |b, c|
    c <=> b
end.first() do |owned_game_entity|
    puts owned_game_entity
end

a&.each do |owned_game_entity|
    puts owned_game_entity
end

puts 'Test end.'
