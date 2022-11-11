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

      def self.find_or_create(db_player, owned_game_entity)
        unless db_player.owned_games_dataset.first(game_id: owned_game_entity.game.remote_id,
                                                   player_id: db_player.remote_id)
          db_game = Database::GameOrm.find_or_create(remote_id: owned_game_entity.game.remote_id)
          db_owned_game = Database::OwnedGameOrm.create(played_time: owned_game_entity.played_time)
          db_owned_game.update(game: db_game)
          db_owned_game.update(player: db_player)
        end
      end
    end
  end
end
