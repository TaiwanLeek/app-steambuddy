# frozen_string_literal: true

module Views
  # View for a single player entity
  class Player
    def initialize(player, index = nil)
      @player = player
      @index = index
    end

    attr_reader :player

    def info_link
      "/player/#{fullname}"
    end

    def index_str
      "player[#{@index}]"
    end

    def player_id
      @player.remote_id
    end

    def player_name
      @player.username
    end

    def player_game_count
      @player.game_count
    end

    def player_friend
      PlayersList.new(@player&.friend_list)
    end

    def fullname
      player_name.to_s
    end

    def total_played_time
      # @player.total_played_time
      @player.owned_games.sum(&:played_time)
    end

    def favorite_game_name
      @player.owned_games[0]&.game&.name
    end

    def favorite_game_played_time
      @player.owned_games[0]&.played_time
    end
  end
end
