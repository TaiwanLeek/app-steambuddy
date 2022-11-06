# frozen_string_literal: true

require_relative '../require_app'
require_app

require_relative '../spec/helpers/test_config_helper'

user = SteamBuddy::Steam::UserMapper
    .new(STEAM_KEY)
    .find(STEAM_ID)

# Add user to database
SteamBuddy::Repository::For.entity(user).create(user)

puts 'Test end.'
