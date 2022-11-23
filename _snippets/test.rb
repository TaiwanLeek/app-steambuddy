# frozen_string_literal: true

=begin
require_relative '../require_app'
require_app

require_relative '../spec/helpers/test_config_helper'

player = SteamBuddy::Steam::PlayerMapper.new(STEAM_KEY).find("76561198326876707")

# SteamBuddy::Repository::For.entity(player).create(player)

players = SteamBuddy::Repository::For.klass(SteamBuddy::Entity::Player).all
=end


remote_id = routing.params['remote_id']

            unless remote_id &&
                   remote_id.length == STEAM_ID64_LENGTH
              flash[:error] = 'Invalid Steam ID!'
              response.status = 400
              routing.redirect '/'
            end

            # Try getting player from database
            db_player = Repository::For.klass(Entity::Player).find_id(remote_id)
            player = Repository::For.klass(Entity::Player).find_id(db_player&.remote_id)

            unless player&.full_friend_data
              # Get player from API
              begin
                player = Steam::PlayerMapper
                  .new(App.config.STEAM_KEY)
                  .find(remote_id)
              rescue StandardError
                flash[:error] = 'Could not find player friends'
              end

              # Add player to database
              begin
                Repository::For.entity(player).find_or_create_with_friends(player)
              rescue StandardError => e
                Logger.error e.backtrace.join("\n")
                flash[:error] = 'Having trouble accessing the database'
              end
            end

            # Add player and player's friends remote_id to session
            session[:watching].insert(0, player.remote_id).uniq!
            player&.friend_list&.each { |friend| session[:watching].insert(0, friend.remote_id).uniq! }

puts 'Test end.'
