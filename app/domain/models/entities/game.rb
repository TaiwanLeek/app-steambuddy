# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module SteamBuddy
  module Entity
    # Domain entity for a game
    class Game < Dry::Struct
      include Dry.Types

      attribute :remote_id, Strict::String
      attribute :name, Strict::String

      def to_attr_hash
        to_hash
      end
    end
  end
end
