# frozen_string_literal: true

require_relative '../require_app'
require_app

require_relative '../spec/helpers/test_config_helper'

user = SteamBuddy::Steam::UserMapper.new(STEAM_KEY).find(STEAM_ID)
app = SteamBuddy::App.new('1')

# Add user to database
test_user = SteamBuddy::Repository::For.entity(user)
#test_user2 = SteamBuddy::Repository::For.entity(user).create(user)

# find user from database
database_user = SteamBuddy::Repository::For.klass(SteamBuddy::Entity::User)
#.find_id("76561198012078200")
                      
puts user
puts app
puts 'Test end.'
