# frozen_string_literal: false

module SteamBuddy
  # Provides access to contributor data
  module Steam
    # Data Mapper: Steam contributor -> PlayedGame entity
    class PlayedGameMapper
      def initialize(gh_token, gateway_class = Steam::Api)
        @token = gh_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def load_several(url)
        @gateway.owned_games_data(url).map do |data|
          PlayedGameMapper.build_entity(data)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
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
