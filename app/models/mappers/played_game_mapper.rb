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

      def find_game_count(steam_id64)
        game_count = @gateway.owned_games_data(steam_id64)['game_count']
        game_count || 0
      end

      def find_games(steam_id64)
        owned_games_data = @gateway.owned_games_data(steam_id64)
        game_list_data = owned_games_data['games']
        return game_list_data unless game_list_data

        game_list_data.map do |data|
          DataMapper.new(steam_id64, data).build_entity
        end
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(steam_id64, data)
          @data = data
          @player_id64 = steam_id64
        end

        def build_entity
          SteamBuddy::Entity::PlayedGame.new(
            player_id64: @player_id64,
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
