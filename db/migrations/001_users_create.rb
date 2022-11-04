# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id

      String      :steam_id64, unique: true
      String      :steam_id, unique: false, null: true
      Integer     :game_count, unique: false, null: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
