# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

require_relative('played_game')

module SteamBuddy
  module Entity
    # Domain entity for team members
    class User < Dry::Struct
      include Dry.Types

      attribute :steamid, Strict::String
      attribute :games_count, Strict::Integer
      attribute :played_games, Strict::Array.of(PlayedGame)
      attribute :friend_list, Strict::Array.of(User)
    end
  end
end
