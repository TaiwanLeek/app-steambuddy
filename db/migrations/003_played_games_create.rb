# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:played_games) do
      primary_key %i[player_id game_id]
      foreign_key :player_id, :players
      foreign_key :game_id, :games

      Integer :played_time, unique: false, null: true

      index %i[player_id game_id]

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
