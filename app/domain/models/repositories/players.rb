# frozen_string_literal: false

module SteamBuddy
  module Repository
    # Repository class for player data accessing
    class Players
      @listed_games_number = 5

      def self.all
        Database::PlayerOrm.all.map { |db_player| rebuild_entity(db_player) }
      end

      def self.find_id(remote_id)
        rebuild_entity_with_friends(Database::PlayerOrm.find(remote_id:))
      end

      def self.rebuild_entity_with_friends(db_player)
        return nil unless db_player

        played_games = db_player.owned_games.map { |db_owned_game| OwnedGames.rebuild_entity(db_owned_game) }
        friend_list = db_player.friends.map { |db_friend| rebuild_entity(db_friend) }

        Entity::Player.new(
          db_player.to_hash.merge(
            played_games:,
            friend_list:
          )
        )
      end

      def self.rebuild_entity(db_player)
        return nil unless db_player

        played_games = db_player.owned_games.map { |db_owned_game| OwnedGames.rebuild_entity(db_owned_game) }

        Entity::Player.new(
          db_player.to_hash.merge(
            played_games:,
            friend_list: nil
          )
        )
      end

      # Create records of one player and all of their friend
      def self.find_or_create_with_friends(entity)
        db_player = find_or_create(entity)

        entity&.friend_list&.each do |friend_entity|
          db_player_friend = find_or_create(friend_entity)

          unless db_player.friends_dataset.first(remote_id: friend_entity.remote_id)
            db_player.add_friend(db_player_friend)
          end
          unless db_player_friend.friends_dataset.first(remote_id: entity.remote_id)
            db_player_friend.add_friend(db_player)
          end
        end
      end

      # Create a record of player in database based on a player entity
      def self.find_or_create(entity)
        db_player = Database::PlayerOrm.find_or_create(entity.to_attr_hash)
        entity&.played_games&.sort do |a, b|
          b.played_time <=> a.played_time
        end&.first(@listed_games_number)&.each do |owned_game_entity|
          OwnedGames.find_or_create(db_player, owned_game_entity)
        end
        db_player
      end
    end
  end
end
