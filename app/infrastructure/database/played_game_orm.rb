# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    # Object-Relational Mapper for Users
    class PlayedGameOrm < Sequel::Model(:played_games)
      many_to_one :player,
                  class: :'SteamBuddy::Database::UserOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(played_game)
        first(appid: played_game[:appid]) || create(played_game)
      end
    end
  end
end
