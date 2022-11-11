# frozen_string_literal: false

module SteamBuddy
  module Repository
    # Repository class for game data accessing
    class OwnedGames
      def self.find_or_create(db_player, owned_game_entity)
        db_game = Database::GameOrm.find_or_create(remote_id: owned_game_entity.game.remote_id)
        db_owned_game = Database::OwnedGameOrm.create(played_time: owned_game_entity.played_time)
        db_owned_game.update(game: db_game)
        db_owned_game.update(player: db_player)
      end
    end
  end
end
