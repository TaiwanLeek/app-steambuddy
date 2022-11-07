# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    # Object-Relational Mapper for Players
    class PlayerOrm < Sequel::Model(:players)
      one_to_many :played_games,
                  class: :'SteamBuddy::Database::PlayedGameOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(player_info)
        first(remote_id: player_info[:remote_id]) || create(player_info)
      end
    end
  end
end
