# frozen_string_literal: true

require 'dry/transaction'

module SteamBuddy
  module Service
    # Transaction to store player from Steam API to database

    # Author: a0985
    class AddPlayer
      include Dry::Transaction

      step :parse_id
      step :find_player
      step :store_player

      private

      def parse_id(input)
        if input.success?
          # Try getting player from database
          db_player = Repository::For.klass(Entity::Player).find_id(input[:remote_id])
          Success(db_player_id: db_player&.remote_id, remote_id: input[:remote_id])
        else
          Failure("ID #{input.error.message.first}")
        end
      end

      def find_player(input)
        player = player_from_database(input)
        if player&.full_friend_data
          input[:local_player] = player
        else
          input[:remote_player] = player_from_steam(input)
        end
        Success(input)
      rescue StandardError => e
        Failure(e.to_s)
      end

      def store_player(input)
        player =
          if input[:remote_player]
            add_player_to_database(input)
          else
            input[:local_player]
          end
        Success(player)
      rescue StandardError => e
        Logger.error e.backtrace.join("\n")
        Failure('Having trouble accessing the database')
      end

      # Following are support methods that other services could use

      def add_player_to_database(input)
        # Add player to database
        new_player = input[:remote_player]
        Repository::For.entity(new_player).find_or_create_with_friends(new_player)
        new_player
      end

      def player_from_steam(input)
        # Get player from API
        Steam::PlayerMapper
          .new(App.config.STEAM_KEY)
          .find(input[:remote_id])
      rescue StandardError
        raise 'Could not find that player on Steam'
      end

      def player_from_database(input)
        Repository::For.klass(Entity::Player).find_id(input[:db_player_id])
      end
    end
  end
end
