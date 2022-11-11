# frozen_string_literal: false

module SteamBuddy
  module Steam
    # Get player data from Api
    class PlayerMapper
      def initialize(steam_key, gateway_class = Steam::Api)
        @key = steam_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key)
      end

      def find(remote_id)
        friend_list_data = @gateway.friend_list_data(remote_id)
        build_entity(remote_id, friend_list_data)
      end

      def build_entity(remote_id, friend_list_data)
        DataMapper.new(remote_id, friend_list_data, @key, @gateway_class).build_entity
      end

      # TODO: Refactor this
      # I can't really describe why we need a datamapper here
      class DataMapper
        def initialize(remote_id, friend_list_data, key, gateway_class)
          @remote_id = remote_id
          @friend_list_data = friend_list_data
          @played_game_mapper = PlayedGameMapper.new(
            key, gateway_class
          )
        end

        def build_entity
          SteamBuddy::Entity::Player.new(
            remote_id: @remote_id,
            username: 'temp_username',
            game_count:,
            played_games:,
            friend_list:
          )
        end

        private

        def game_count
          @played_game_mapper.find_game_count(@remote_id)
        end

        def played_games
          @played_game_mapper.find_games(@remote_id)
        end

        def friend_list
          @friend_list_data.map do |friend_data|
            friend_steam_id = friend_data['steamid']
            SteamBuddy::Entity::Player.new(
              remote_id: friend_steam_id,
              username: 'temp_username',
              game_count: @played_game_mapper.find_game_count(friend_steam_id),
              played_games: @played_game_mapper.find_games(friend_steam_id),
              friend_list: nil
            )
          end
        end
      end
    end
  end
end
