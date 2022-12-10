# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'game_representer'

module SteamBuddy
  module Representer
    class OwnedGame < Roar::Decorator
      include Roar::JSON

      property :game, extend: Representer::Game
      property :played_time
    end
  end
end
