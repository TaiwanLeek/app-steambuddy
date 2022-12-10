# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'game_representer'

module SteamBuddy
  module Representer
    class Player < Roar::Decorator
      include Roar::JSON

      property :remote_id
      property :username
      property :game_count
      property :full_friend_data
      collection :owned_games, extend: Representer::OwnedGame
      collection :friend_list, extend: Representer::Player
    end
  end
end
