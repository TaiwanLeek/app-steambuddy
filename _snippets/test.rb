# frozen_string_literal: true

require_relative '../require_app'
require_app

require_relative '../spec/helpers/test_config_helper'

user = SteamBuddy::Steam::UserMapper.new(STEAM_KEY).find(STEAM_ID)
app = SteamBuddy::App.new('1')
api = SteamBuddy::Steam::Api.new("C450FFC18AD99BD334178BF3546E8CD5").friend_list_data('76561198012078200')

# Add user to database
test_user = SteamBuddy::Repository::For.entity(user)
#test_user2 = SteamBuddy::Repository::For.entity(user).create(user)

# find user from database
database_user = SteamBuddy::Repository::For.klass(SteamBuddy::Entity::User)
#.find_id("76561198012078200")
                      
=begin
SteamBuddy::Entity::User.new(
            steam_id64: @steam_id,
            steam_id: "bamboo",
            game_count:,
            played_games:,
            friend_list:
          )
=end
puts user
puts app
puts 'Test end.'
