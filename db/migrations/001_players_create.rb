# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:players) do
      primary_key :id

      String      :remote_id, unique: true
      String      :username, unique: false
      Integer     :game_count, unique: false, null: true
      Boolean     :full_friend_data, unique: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
