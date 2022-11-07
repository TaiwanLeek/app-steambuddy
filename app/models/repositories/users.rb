# frozen_string_literal: true

module SteamBuddy
  module Repository
    # Repository for Players
    class Players
      def self.find_id(steam_id64)
        rebuild_entity Database::PlayerOrm.first(steam_id64:)
      end

      def self.all
        Database::PlayerOrm.all.map { |db_player| rebuild_entity(db_player) }
      end

      def self.find(entity)
        find_id(entity.steam_id64)
      end

      def self.create(entity)
        # raise 'Player already exists' if find(entity)

        PersistPlayer.new(entity).call
        rebuild_entity(entity)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        # Notice: in players entity, there are played_gmaes & friend_list attributes
        # but in players db, these two attributes don't exist, so they got nil value
        Entity::Player.new(
          steam_id64: db_record.steam_id64,
          steam_id: db_record.steam_id,
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

      def self.db_find_or_create(entity)
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
          Players.db_find_or_create(@entity)
          @entity&.played_games&.each do |game|
            PlayedGames.db_find_or_create(game)
          end
        end
      end
    end
  end
end
