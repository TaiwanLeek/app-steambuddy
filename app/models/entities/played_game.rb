# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module SteamBuddy
  module Entity
    # Domain entity for team members
    class PlayedGame < Dry::Struct
      include Dry.Types

      attribute :appid, Strict::Integer
      attribute :played_time, Strict::Integer
    end
  end
end
