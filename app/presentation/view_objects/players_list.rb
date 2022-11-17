# frozen_string_literal: true

require_relative 'player'

# Making front-end viewable
module Views
  # View for a list of player entities
  class PlayersList
    def initialize(players)
      @players = players.map.with_index { |proj, i| Player.new(proj, i) }
    end

    def each(&)
      @players.each(&)
    end

    def any?
      @players.any?
    end
  end
end
