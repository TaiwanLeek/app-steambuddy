# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

require_relative('game')

module SteamBuddy
  module Entity
    # Domain entity for a game that has been played by a player
    class PlayedGame < Dry::Struct
      include Dry.Types

      attribute :game, Game
      attribute :played_time, Strict::Integer

      def to_attr_hash
        to_hash
      end
    end
  end
end
