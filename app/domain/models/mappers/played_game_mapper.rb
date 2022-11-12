# frozen_string_literal: false

MINUTES_IN_AN_HOUR = 60

module SteamBuddy
  module Steam
    # Get played games data from Api
    class PlayedGameMapper
      def initialize(steam_key, gateway_class = Steam::Api)
        @key = steam_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key)
      end

      def find_game_count(remote_id)
        game_count = @gateway.owned_games_data(remote_id)['game_count']
        game_count || 0
      end

      def find_games(remote_id)
        owned_games_data = @gateway.owned_games_data(remote_id)
        game_list_data = owned_games_data['games']
        return game_list_data unless game_list_data

        game_list_data.map do |data|
          DataMapper.new(data).build_entity
        end
      end

      # TODO: Refactor this
      # I can't really describe why we need a datamapper here
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          SteamBuddy::Entity::PlayedGame.new(
            game:,
            played_time:
          )
        end

        private

        def played_time
          @data['playtime_forever'].to_i / MINUTES_IN_AN_HOUR
        end

        def game
          SteamBuddy::Entity::Game.new(remote_id: @data['appid'].to_s)
        end
      end
    end
  end
end
