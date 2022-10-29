# frozen_string_literal: false

module SteamBuddy
  # Provides access to contributor data
  module Steam
    # Data Mapper: Steam contributor -> PlayedGame entity
    class PlayedGameMapper
      def initialize(steam_key, gateway_class = Steam::Api)
        @key = steam_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key)
      end

      def find_game_count(steam_id)
        @gateway.owned_games_data(steam_id)['game_count']
      end

      def find_games(steam_id)
        owned_games_data = @gateway.owned_games_data(steam_id)
        game_list_data = owned_games_data['games']
        build_entities(game_list_data)
      end

      def build_entities(game_list_data)
        game_list_data.map do |data|
          DataMapper.new(data).build_entity
        end
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          SteamBuddy::Entity::PlayedGame.new(
            appid:,
            played_time:
          )
        end

        private

        def appid
          @data['appid']
        end

        def played_time
          @data['playtime_forever']
        end
      end
    end
  end
end
