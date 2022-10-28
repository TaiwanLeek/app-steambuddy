# frozen_string_literal: false

module SteamBuddy
  # Provides access to contributor data
  module Steam
    # Data Mapper: Steam contributor -> User entity
    class UserMapper
      def initialize
        @token = gh_token
      end
    end

    # Extracts entity specific elements from data structure
    class DataMapper
      def initialize(data)
        @data = data
      end

      def build_entity
        Entity::User.new(
          steamid:,
          games_count:,
          played_games:,
          friend_list:
        )
      end

      private

      def steamid
        @data['steamid']
      end

      def games_count
        @data['games_count']
      end

      def played_games
        @data['played_games']
      end

      def friend_list
        @data['friend_list']
      end
    end
  end
end
