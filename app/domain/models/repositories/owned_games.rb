# frozen_string_literal: false

module SteamBuddy
  module Repository
    # Repository class for game data accessing
    class OwnedGames
      def self.rebuild_entity(db_owned_game)
        return nil unless db_owned_game

        game = Entity::Game.new(remote_id: db_owned_game.game.remote_id)
        Entity::PlayedGame.new(game:, played_time: db_owned_game.played_time)
      end

      def self.create(db_player, owned_game_entity)
        db_game = Database::GameOrm.find_or_create(remote_id: owned_game_entity.game.remote_id)
        return if db_player.owned_games_dataset.first(game_id: db_game.id,
                                                      player_id: db_player.id)

        db_owned_game = Database::OwnedGameOrm.create(played_time: owned_game_entity.played_time)
        db_owned_game.update(game: db_game).update(player: db_player)
      end
    end
  end
end
