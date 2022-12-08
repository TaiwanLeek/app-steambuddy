# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module SteamBuddy
  module Representer
    class Player < Roar::Decorator
      include Roar::JSON

      property :remote_id
      property :username
      property :game_count
      property :owned_games
    end
  end
end
