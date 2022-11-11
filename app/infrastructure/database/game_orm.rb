# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    class GameOrm < Sequel::Model(:games)
      plugin :timestamps, update_on_create: true
    end
  end
end
