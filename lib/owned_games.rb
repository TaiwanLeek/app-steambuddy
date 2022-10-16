module SteamCircle
    class OwnedGames
      attr_reader :games_count
      attr_reader :games

      def initialize(game_count, games)
        @game_count = game_count
        @games = games
      end

      def count
        @game_count
      end
    end
  end 