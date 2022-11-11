# frozen_string_literal: true

module SteamBuddy
  module Repository
    # Repository for PlayedGames
    class PlayedGames
      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::PlayedGame.new(
          player_remote_id: db_record.player_remote_id,
          remote_id: db_record.remote_id,
          played_time: db_record.played_time
        )
      end

      def self.find_or_create(entity)
        Database::PlayedGameOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
