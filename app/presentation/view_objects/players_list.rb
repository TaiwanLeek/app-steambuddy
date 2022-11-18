# frozen_string_literal: true

require_relative 'player'

# Making front-end viewable
module Views
  # View for a list of player entities
  class PlayersList
    def initialize(players)
      @viewable_players = players.map.with_index { |proj, i| Player.new(proj, i) }
    end

    def each(&)
      @viewable_players.each(&)
    end

    def any?
      @viewable_players.any?
    end

    ##
    # Given an array of remote_id, return only the players that within this array.
    # Author: pride829
    # @param [Array<String>] remote_ids
    # @return [Array<Entity::Player>]
    def filter(remote_ids)
      @viewable_players.select { |viewable_player| remote_ids.include? viewable_player.player.remote_id }
    end
  end
end
