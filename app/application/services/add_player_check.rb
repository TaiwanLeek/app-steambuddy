# frozen_string_literal: true

require 'dry/transaction'

module SteamBuddy
  module Service
    # Chech if input is valid or not

    # Author: a0985
    class AddPlayerCheck
      include Dry::Transaction

      step :validate_input

      private

      DB_ERR_MSG = 'Having trouble accessing the database'
      GH_NOT_FOUND_MSG = 'Could not find that player on Steam'

      def validate_input(input)
        if input.success?
          Success(input)
        else
          Failure(input.errors.to_h[:remote_id][0])
        end
      end
    end
  end
end
