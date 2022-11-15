# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

require_relative('played_game')

module SteamBuddy
  module Entity
    # Domain entity for team members
    class Player < Dry::Struct
      include Dry.Types

      attribute :remote_id, Strict::String
      attribute :username, Strict::String
      attribute :game_count, Strict::Integer
      attribute :full_friend_data, Strict::Bool
      attribute :played_games, Array.of(PlayedGame).optional
      attribute :friend_list, Array.of(Player).optional

      def to_attr_hash
        to_hash.except(:played_games, :friend_list)
      end

      def total_played_time
        played_games ? played_games.sum(&:played_time) : 0
      end

      def favorite_game
        played_games&.min { |played_game_a, played_game_b| played_game_b.played_time <=> played_game_a.played_time }
      end
    end
  end
end
