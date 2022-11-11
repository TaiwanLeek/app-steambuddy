# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    class PlayerOrm < Sequel::Model(:players)
      many_to_many :friends,
                   class: :'SteamBuddy::Database::PlayerOrm',
                   join_table: :friends,
                   left_key: :player_id, right_key: :player_friend_id

      plugin :timestamps, update_on_create: true
    end
  end
end
