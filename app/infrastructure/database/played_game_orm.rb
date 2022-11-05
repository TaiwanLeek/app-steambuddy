# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    # Object-Relational Mapper for Users
    class PlayedGameOrm < Sequel::Model(:played_games)
      plugin :timestamps, update_on_create: true

    end
  end
end