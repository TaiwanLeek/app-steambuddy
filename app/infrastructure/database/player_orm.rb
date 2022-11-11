# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    # Model for player data accessing
    class PlayerOrm < Sequel::Model(:players)
      many_to_many :friends,
                   class: :'SteamBuddy::Database::PlayerOrm',
                   join_table: :friends,
                   left_key: :player_id, right_key: :player_friend_id

      one_to_many :owned_games,
                  class: :'SteamBuddy::Database::OwnedGameOrm',
                  key: :player_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(player_info)
        first(remote_id: player_info[:remote_id]) || create(player_info)
      end
    end
  end
end
