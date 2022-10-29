# frozen_string_literal: true

require_relative 'require_app'
require_app

require_relative 'spec/read_config'

user = SteamBuddy::Steam::UserMapper.new(STEAM_KEY).find(STEAM_ID)

puts user
