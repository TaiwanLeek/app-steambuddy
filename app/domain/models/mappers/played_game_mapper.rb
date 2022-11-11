# frozen_string_literal: false

module SteamBuddy
  module Steam
    # Get played games data from Api
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

      # TODO: Refactor this
      # I can't really describe why we need a datamapper here
      class DataMapper
        def initialize(steam_id64, data)
          @data = data
          @player_id64 = steam_id64
        end

        def build_entity
          SteamBuddy::Entity::PlayedGame.new(
            player_remote_id: @player_id64,
            game:,
            played_time:
          )
        end

        private

        def played_time
          @data['playtime_forever']
        end

        def game
          SteamBuddy::Entity::Game.new(remote_id: @data['appid'])
        end
      end
    end
  end
end
