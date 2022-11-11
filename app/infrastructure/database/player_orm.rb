# frozen_string_literal: true

require 'sequel'

module SteamBuddy
  module Database
    class PlayerOrm < Sequel::Model(:players)
      plugin :timestamps, update_on_create: true
    end
  end
end
