# frozen_string_literal: true

require 'dry/transaction'

module SteamBuddy
  module Service
    # Transaction to store player from Steam API to database

    # Author: a0985
    class GetTable
      include Dry::Transaction

      step :find_player
      step :friend_sort

      private

      def find_player(input)
        # Get player from database
        player = Repository::For.klass(Entity::Player).find_id(input[:remote_id])
        player ||= player_from_steam(input)

        input[:player_info] = player
        Success(input)
      rescue StandardError
        Failure('Having touble to find player')
      end

      def friend_sort(input)
        Steam::PlayerMapper::DataHelper.friend_sort!(input[:player_info], input[:info_value])
        player = input[:player_info]
        Success(player)
      rescue StandardError => e
        Logger.error e.backtrace.join("\n")
        Failure('Table accessing has some error')
      end

      # Following are support methods that other services could use

      def player_from_steam(input)
        # Get player from API
        Steam::PlayerMapper
          .new(App.config.STEAM_KEY)
          .find(input[:remote_id])
      end
    end
  end
end
