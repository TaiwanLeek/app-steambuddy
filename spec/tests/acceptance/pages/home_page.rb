# frozen_string_literal: true

# Page object for home page
class HomePage
  include PageObject

  page_url SteamBuddy::App.config.APP_HOST

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  h1(:title_heading, id: 'main_header')
  text_field(:id_input, id: 'id_input')
  button(:add_button, id: 'player_form_submit')
  table(:players_table, id: 'players_table')

  indexed_property(
    :players,
    [
      [:span, :SteamID64,        { id: 'player[%s].player_id' }],
      [:span, :Personal_Name,    { id: 'player[%s].player_name' }],
      [:span, :Game_Count,       { id: 'player[%s].player_game_count' }]
    ]
  )

  def first_player
    players[0]
  end

  def first_player_row
    players_table_element.trs[1]
  end

  def first_player_delete
    first_player_row.button(id: 'player[0].delete').click
  end

  def first_player_hover
    first_player_row.hover
  end

  def first_player_highlighted?
    first_player_row.style('background-color').eql? 'rgba(0, 0, 0, 0.075)'
  end

  def num_players
    players_table_element.rows - 1
  end

  def add_new_player(remote_id)
    self.id_input = remote_id
    add_button
  end

  def listed_player(player)
    {
      id: player.player_id.text,
      name: player.player_name.text,
      game_count: player.player_game_count.text
    }
  end
end
