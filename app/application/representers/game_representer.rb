# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module SteamBuddy
  module Representer
    class Game < Roar::Decorator
      include Roar::JSON

      property :remote_id
      property :name
    end
  end
end
