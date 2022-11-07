# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    # Object-Relational Mapper for Players
    class PlayerOrm < Sequel::Model(:players)
      one_to_many :played_games,
                  class: :'SteamBuddy::Database::PlayedGameOrm',
                  key: :owner_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(player)
        first(steam_id64: player[:steam_id64]) || create(player)
      end
    end
  end
end
