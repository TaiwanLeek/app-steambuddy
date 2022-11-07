# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    # Object-Relational Mapper for Players
    class GameOrm < Sequel::Model(:games)
      plugin :timestamps, update_on_create: true
    end
  end
end
