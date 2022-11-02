# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id

      String      :steam_id, unique: true
      Integer     :game_count, unique: false, null: true
      String      :played_games, unique: false, null: true
      String      :friend_list, unique: false, null: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
