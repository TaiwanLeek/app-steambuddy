# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    class OwnedGameOrm < Sequel::Model(:owned_games)
      many_to_one :game,
                  class: :'SteamBuddy::Database::GameOrm'
      many_to_one :player,
                  class: :'SteamBuddy::Database::PlayerOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
