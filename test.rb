# frozen_string_literal: true

require_relative 'require_app'
require_app

require_relative 'spec/read_config'

friend_list = SteamBuddy::Steam::Api.new(STEAM_KEY)
  .friend_list_data(STEAM_ID)

owned_games = SteamBuddy::Steam::Api.new(STEAM_KEY)
  .owned_games_data(STEAM_ID)

puts friend_list

puts owned_games
