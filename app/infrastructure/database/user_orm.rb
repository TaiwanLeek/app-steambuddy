# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    # Object-Relational Mapper for Users
    class UserOrm < Sequel::Model(:users)
      one_to_many :played_games,
                  class: :'SteamBuddy::Database::PlayedGameOrm',
                  key: :owner_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(user)
        first(steam_id64: user[:steam_id64]) || create(user)
      end
    end
  end
end
