# frozen_string_literal: false

MINUTES_IN_AN_HOUR = 60

module SteamBuddy
  module Steam
    # Get played games data from Api
    class OwnedGameMapper
      def initialize(steam_key, gateway_class = Steam::Api)
        @key = steam_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key)
        @listed_games_number = 1
      end

      def find_game_count(remote_id)
        game_count = @gateway.owned_games_data(remote_id)['game_count']
        game_count || 0
      end

      def find_games(remote_id)
        owned_games_data = @gateway.owned_games_data(remote_id)
        game_list_data = owned_games_data['games']
        return game_list_data unless game_list_data

        game_list_data.sort! do |game_a, game_b|
          game_b['playtime_forever'] <=> game_a['playtime_forever']
        end

        game_list_data.first(@listed_games_number).map do |data|
          build_entity(data)
        end
      end

      def build_entity(data)
        SteamBuddy::Entity::OwnedGame.new(
          game: game(data),
          played_time: played_time(data)
        )
      end

      private

      def played_time(data)
        data['playtime_forever'].to_i / MINUTES_IN_AN_HOUR
      end

      def game(data)
        remote_id = data['appid'].to_s
        name = @gateway.game_name(remote_id) || ''
        SteamBuddy::Entity::Game.new(remote_id:, name:)
      end
    end
  end
end
