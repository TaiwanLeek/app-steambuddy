# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:played_games) do
      primary_key :id
      foreign_key :player_id, :users

      Integer     :appid, unique: false, null: true
      Integer     :played_time, unique: false, null: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
