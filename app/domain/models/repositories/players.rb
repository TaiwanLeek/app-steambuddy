# frozen_string_literal: false

module SteamBuddy
  module Repository
    # Repository class for player data accessing
    class Players
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
        entity&.played_games&.each do |owned_game_entity|
          OwnedGames.find_or_create(db_player, owned_game_entity)
        end
        db_player
      end
    end
  end
end
