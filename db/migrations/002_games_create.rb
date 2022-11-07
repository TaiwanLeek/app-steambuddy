# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:games) do
      primary_key :id

      Integer     :remote_id, unique: false, null: true
      String :title, unique: false, null: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
