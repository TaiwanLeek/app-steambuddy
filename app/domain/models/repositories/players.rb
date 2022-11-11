# fronzen_string_literal: true

module SteamBuddy
  module Repository
    # Repository class for player data accessing
    class Players
      # Create a record of player in database based on a player entity
      def self.create(entity)
        Database::PlayerOrm.create(entity.to_attr_hash)
      end
    end
  end
end
