# frozen_string_literal: false

module SteamBuddy
  # Provides access to contributor data
  module Steam
    # Data Mapper: Steam contributor -> PlayedGame entity
    class PlayedGameMapper
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
        Entity::PlayedGame.new(
          appid:,
          played_time:
        )
      end

      private

      def appid
        @data['appid']
      end

      def played_time
        @data['played_time']
      end
    end
  end
end
