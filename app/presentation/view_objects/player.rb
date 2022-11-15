# frozen_string_literal: true

module Views
  # View for a single player entity
  class Player
    def initialize(player, index = nil)
      @player = player
      @index = index
    end

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

    def fullname
      "#{player_name}"
    end
  end
end

# tr class="table-row player_row" data-href="player/#{player.username}" id="player[#{index}].row"
#               td id='td_id'
#                 span class="player_table_id" id="player[#{index}].remote_id"
#                   = player.remote_id
#               td id='td_name'
#                 span class="player_table_name" id="player[#{index}].username"
#                   = player.username
#               td id='td_game_count'
#                 span class="player_table_game_count" id="player[#{index}].game_count"
#                   = player.game_count
