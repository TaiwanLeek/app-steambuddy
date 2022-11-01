# frozen_string_literal: true

module SteamBuddy
  module Repository
    # Repository for Members
    class Users
      def self.find_id(steam_id)
        rebuild_entity Database::UserOrm.first(steam_id:)
      end
    end
  end
end
