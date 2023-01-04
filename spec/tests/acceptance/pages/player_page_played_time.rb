# frozen_string_literal: true

# Page object for home page
class PlayerPage
  include PageObject

  page_url SteamBuddy::App.config.APP_HOST +
           '/player/<%=params[:remote_id]%>' \
           '<%=params[:info_value] ? "/#{params[:info_value]}" : ""%>'

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  table(:played_time_table, id: 'played_time_table')

  indexed_property(
    :players1,
    [
      [:span, :player_id, { id: 'player.player_id' }],
      [:span, :player_name, { id: 'player.player_name' }],
      [:span, :player_total_played_time, { id: 'player.total_played_time' }],
      [:span, :friend_id, { id: 'friend.player_id' }],
      [:span, :friend_name, { id: 'friend.player_name' }],
      [:span, :friend_total_played_time, { id: 'friend.total_played_time' }]
    ]
  )
end
