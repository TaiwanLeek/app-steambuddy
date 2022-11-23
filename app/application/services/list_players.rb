# frozen_string_literal: true

require 'dry/monads'

module SteamBuddy
  module Service
    # Retrieves array of all listed player entities

    # Author: a0985
    class ListPlayers
      include Dry::Monads::Result::Mixin

      ##
      # Get all players from database
      # Author: a0985
      # @return [Array<Entity::Player>]
      def call
        players = Repository::For.klass(Entity::Player).all

        Success(players)
      rescue StandardError
        Failure('Having trouble accessing the database')
      end
    end
  end
end
