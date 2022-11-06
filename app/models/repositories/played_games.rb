# frozen_string_literal: true

module SteamBuddy
  module Repository
    # Repository for PlayedGames
    class PlayedGames
      def self.find_id(id)
        rebuild_entity Database::PlayedGameOrm.first(id:)
      end

      def self.find_playedgame(playedgame)
        rebuild_entity Database::PlayedGameOrm.first(playedgame:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::PlayedGame.new(
          player_id64: db_record.player_id64,
          appid: db_record.appid,
          played_time: db_record.played_time
        )
      end

      def self.db_find_or_create(entity)
        Database::PlayedGameOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
