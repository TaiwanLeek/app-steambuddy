# frozen_string_literal: true

require 'dry/transaction'

module SteamBuddy
  module Service
    # Retrieves array of all listed player entities
    class ListPlayers
      include Dry::Transaction

      step :get_api_list
      step :reify_list

      private

      def get_api_list(players_list)
        Gateway::Api.new(SteamBuddy::App.config)
          .players_list(players_list)
          .then do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      rescue StandardError
        Failure('Could not access our API')
      end

      def reify_list(players_json)
        Representer::PlayersList.new(OpenStruct.new)
          .from_json(players_json)
          .then { |players| Success(players) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
