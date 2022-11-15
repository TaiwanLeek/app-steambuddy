# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:friends) do
      primary_key %i[player_id player_friend_id]
      foreign_key :player_id, :players
      foreign_key :player_friend_id, :players

      index %i[player_id player_friend_id]
    end
  end
end
