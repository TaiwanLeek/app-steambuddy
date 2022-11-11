# frozen_string_literal: false

module SteamBuddy
  module Repository
    # Repository class for game data accessing
    class Games
      def self.find_or_create(remote_id)
        Database::GameOrm.find_or_create(remote_id:)
      end
    end
  end
end
