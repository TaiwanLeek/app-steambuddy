# frozen_string_literal: true

module SteamBuddy
  # Get game lists from the given steamid
  class OwnedGames
    attr_reader :games_count, :games

    def initialize(game_count, games)
      @game_count = game_count
      @games = games
    end

    def count
      @game_count
    end
  end
end
