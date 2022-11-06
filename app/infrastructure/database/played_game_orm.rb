# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    # Object-Relational Mapper for Users
    class PlayedGameOrm < Sequel::Model(:played_games)
      many_to_one :user,
                  class: :'SteamBuddy::Database::UserOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(game_info)
        first(appid: game_info[:appid]) || create(game_info)
      end
    end
  end
end
