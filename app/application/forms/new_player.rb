# frozen_string_literal: true

require 'dry-validation'

STEAM_ID64_LENGTH = 17

module SteamBuddy
  module Forms
    # Detect whether input ID is legal
    class NewPlayer < Dry::Validation::Contract
      ID64_REGEX = /^\d{17}$/

      params do
        required(:remote_id).filled(:string)
      end

      rule(:remote_id) do
        key.failure('Invalid Steam ID!') unless ID64_REGEX.match?(value)
      end
    end
  end
end
