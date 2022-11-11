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
      attribute :game_count, Integer.optional
      attribute :played_games, Array.of(PlayedGame).optional
      attribute :friend_list, Array.of(Player).optional

      def to_attr_hash
        to_hash.except(:played_games, :friend_list)
      end

      def total_played_time
        sum = 0
        return sum if played_games.nil?

        played_games.each do |games|
          sum += games.played_time
        end
        sum/60
      end

      def favorite_game
        max_time = 0
        fav_id = nil
        return "None", 0 if played_games.nil?

        played_games.each do |games|
          fav_id, max_time = games.played_time > max_time ? [games.remote_id, games.played_time] : [fav_id, max_time]
        end
        return fav_id, max_time/60
      end
    end
  end
end
