# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    # Model for game data accessing
    class GameOrm < Sequel::Model(:games)
      plugin :timestamps, update_on_create: true
    end
  end
end
