# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module SteamBuddy
  module Entity
    # Domain entity for team members
    class PlayedGame < Dry::Struct
      include Dry.Types

      attribute :player_remote_id, Strict::String
      attribute :remote_id, Strict::Integer
      attribute :played_time, Strict::Integer

      def to_attr_hash
        to_hash.except(:player_remote_id, :remote_id)
      end
    end
  end
end
