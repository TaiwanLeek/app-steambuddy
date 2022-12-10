# frozen_string_literal: true

require 'dry/transaction'

module SteamBuddy
  module Service
    # Retrieves array of all listed player entities
    class ListPlayers
      include Dry.transaction

      step :get_api_list

      private

      def get_api_list; end
    end
  end
end
