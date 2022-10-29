# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

require_relative('played_game')

module SteamBuddy
  module Entity
    # Domain entity for team members
    class User < Dry::Struct
      include Dry.Types

      attribute :steam_id, Strict::String
      attribute :games_count, Integer.optional
      attribute :played_games, Array.of(PlayedGame).optional
      attribute :friend_list, Array.of(User).optional
    end
  end
end
