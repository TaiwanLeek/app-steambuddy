# frozen_string_literal: true

require 'dry/monads'

module SteamBuddy
  module Service
    # Retrieves array of all listed project entities
    class ListProjects
      include Dry::Monads::Result::Mixin

      def call
        players = Repository::For.klass(Entity::Player).all

        Success(players)
      rescue StandardError
        Failure('Having trouble accessing the database')
      end
    end
  end
end
