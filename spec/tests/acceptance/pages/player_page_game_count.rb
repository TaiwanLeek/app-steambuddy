# frozen_string_literal: true

# Page object for home page
class PlayerPage
  include PageObject

  page_url SteamBuddy::App.config.APP_HOST +
           '/player/<%=params[:remote_id]%>' \
           '<%=params[:info_value] ? "/#{params[:info_value]}" : ""%>'

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  table(:game_count_table, id: 'game_count_table')

  indexed_property(
    :players0,
    [
      [:span, :player_id, { id: 'player.player_id' }],
      [:span, :player_name, { id: 'player.player_name' }],
      [:span, :player_game_count, { id: 'player.player_game_count' }],
      [:span, :friend_id, { id: 'friend.player_id' }],
      [:span, :friend_name, { id: 'friend.player_name' }],
      [:span, :friend_game_count, { id: 'friend.player_game_count' }]
    ]
  )
end
