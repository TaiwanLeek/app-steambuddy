# frozen_string_literal: true

module SteamBuddy
  module Repository
    # Repository for Players
    class Players
      def self.find_id(remote_id)
        rebuild_entity Database::PlayerOrm.first(remote_id:)
      end

      def self.all
        Database::PlayerOrm.all.map { |db_player| rebuild_entity(db_player) }
      end

      def self.find(entity)
        find_id(entity.remote_id)
      end

      def self.create(entity)
        PersistPlayer.new(entity).call
        rebuild_entity(entity)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        # TODO: Add played_games and friend_list
        Entity::Player.new(
          remote_id: db_record.remote_id,
          username: db_record.username,
          game_count: db_record.game_count,
          played_games: nil,
          friend_list: nil
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Players.rebuild_entity(db_member)
        end
      end

      def self.find_or_create(entity)
        Database::PlayerOrm.find_or_create(entity.to_attr_hash)
      end

      # Helper class to persist player and its games to database
      class PersistPlayer
        def initialize(entity)
          @entity = entity
        end

        def create_player
          Database::PlayerOrm.create(@entity.to_attr_hash)
        end

        def call
          Players.find_or_create(@entity)
          @entity&.played_games&.each do |game|
            PlayedGames.find_or_create(game)
          end
        end
      end
    end
  end
end
