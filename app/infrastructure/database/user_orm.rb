# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    # Object-Relational Mapper for Users
    class UserOrm < Sequel::Model(:users)
      one_to_many :user_id64,
                  class: :'SteamBuddy::Database::PlayedGameOrm',
                  key: :player_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(user_info)
        first(steam_id64: user_info[:steam_id64]) || create(user_info)
      end
    end
  end
end
