# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'openstruct_with_links'
require_relative 'player_representer'

module SteamBuddy
  module Representer
    class PlayersList < Roar::Decorator
      include Roar::JSON

      collection  :players, extend: Representer::Player, class: Response::OpenStructWithLinks
    end
  end
end
