# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:players) do
      primary_key :id

      String      :remote_id, unique: true
      String      :playername, unique: false, null: true
      Integer     :game_count, unique: false, null: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
