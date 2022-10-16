module SteamCircle
    class OwnedGames
      def initialize(game_count, games)
        @game_count = game_count
        @games = games
      end
  
      def count
        @game_count
      end
      
      def games
        @games
      end

    end
  end
  