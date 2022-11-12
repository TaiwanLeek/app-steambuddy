# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:owned_games) do
      primary_key :id
      foreign_key :game_id, :games
      foreign_key :player_id, :players

      Integer     :played_time, unique: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
