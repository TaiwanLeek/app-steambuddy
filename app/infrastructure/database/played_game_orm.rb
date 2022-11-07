# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    # Object-Relational Mapper for Players
    class PlayedGameOrm < Sequel::Model(:played_games)
      many_to_one :player,
                  class: :'SteamBuddy::Database::PlayerOrm',
                  key: :player_id

      many_to_one :game,
                  class: :'SteamBuddy::Database::GameOrm',
                  key: :game_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(played_game_info)
        first(played_time: played_game_info[:played_time] || create(played_game_info))
      end
    end
  end
end
