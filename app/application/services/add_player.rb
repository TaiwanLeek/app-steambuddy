# frozen_string_literal: true

require 'dry/transaction'

module SteamBuddy
  module Service
    # Transaction to store project from Github API to database

    # Author: a0985
    class AddPlayer
      include Dry::Transaction

      step :request_player
      step :reify_player

      private

      def request_player(input)
        result = Gateway::Api.new(SteamBuddy::App.config)
          .add_player(input[:remote_id])

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot add players right now; please try again later')
      end

      def reify_player(player_json)
        Representer::Player.new(OpenStruct.new)
          .from_json(player_json)
          .then { |player| Success(player) }
      rescue StandardError
        Failure('Error in the player -- please try again')
      end
    end
  end
end
