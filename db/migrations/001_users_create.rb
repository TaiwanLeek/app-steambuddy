# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id

      Integer     :steam_id, unique: true
      Integer     :game_count, unique: false, null: false
      String      :played_games, unique: false. null: true
      String      :friend_list, unique: false, null: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
