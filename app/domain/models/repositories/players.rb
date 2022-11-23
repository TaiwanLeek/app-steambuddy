# frozen_string_literal: false

module SteamBuddy
  module Repository
    # Repository class for player data accessing
    class Players
      Listed_Games_Number = 1

      def self.all
        Database::PlayerOrm.all.map { |db_player| rebuild_entity(db_player) }
      end

      def self.find_id(remote_id)
        return unless remote_id

        db_player = Database::PlayerOrm.find(remote_id:)
        return unless db_player

        if db_player.full_friend_data
          rebuild_entity_with_friends(db_player)
        else
          rebuild_entity(db_player)
        end
      end

      def self.rebuild_entity_with_friends(db_player)
        return unless db_player

        Entity::Player.new(
          db_player.to_hash.merge(
            owned_games: rebuild_games_entity(db_player),
            friend_list: rebuild_friends_entity(db_player),
            full_friend_data: true
          )
        )
      end

      def self.rebuild_entity(db_player)
        return unless db_player

        Entity::Player.new(
          db_player.to_hash.merge(
            owned_games: rebuild_games_entity(db_player),
            friend_list: nil
          )
        )
      end

      def self.rebuild_games_entity(db_player)
        db_player.owned_games&.map { |db_owned_game| OwnedGames.rebuild_entity(db_owned_game) }
      end

      def self.rebuild_friends_entity(db_player)
        db_player.friends&.map { |db_friend| rebuild_entity(db_friend) }
      end

      # Create records of one player and all of their friend
      def self.find_or_create_with_friends(entity)
        db_player = find_or_create(entity)

        entity&.friend_list&.each do |friend_entity|
          db_player_friend = find_or_create(friend_entity)
          players_add_friend(db_player, db_player_friend)
        end
        db_player.update(full_friend_data: true)
        db_player
      end

      def self.players_add_friend(db_player, db_player_friend)
        unless db_player.friends_dataset.first(remote_id: db_player_friend.remote_id)
          db_player.add_friend(db_player_friend)
        end

        return if db_player_friend.friends_dataset.first(remote_id: db_player.remote_id)

        db_player_friend.add_friend(db_player)
      end

      # Create a record of player in database based on a player entity
      def self.find_or_create(entity)
        return unless entity

        db_player = Database::PlayerOrm.find_or_create(entity.to_attr_hash)
        sort_owned_games(db_player, entity)

        db_player
      end

      def self.sort_owned_games(db_player, entity)
        entity&.owned_games&.sort do |owned_game_a, owned_game_b|
          owned_game_b.played_time <=> owned_game_a.played_time
        end&.first(Listed_Games_Number)&.each do |owned_game_entity|
          OwnedGames.create(db_player, owned_game_entity)
        end
      end
    end
  end
end
