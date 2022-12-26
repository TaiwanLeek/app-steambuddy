# frozen_string_literal: true

# Page object for home page
class PlayerPage
  include PageObject

  page_url SteamBuddy::App.config.APP_HOST +
           '/player/<%=params[:remote_id]%>' \
           '<%=params[:info_value] ? "/#{params[:info_value]}" : ""%>'

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')
end
