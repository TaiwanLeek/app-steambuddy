# frozen_string_literal: true

require 'roda'
require 'slim'

STEAM_ID64_LENGTH = 17

module SteamBuddy
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, path: 'app/views/assets',
                    css: 'style.css', js: 'table_row_click.js'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        players = Repository::For.klass(Entity::Player).all
        view 'home', locals: { players: }
      end

      routing.on 'player' do
        routing.is do
          # POST /player/
          routing.post do
            remote_id = routing.params['remote_id']
            routing.halt 400 unless remote_id &&
                                    remote_id.length == STEAM_ID64_LENGTH

            # Get player from Steam
            player = Steam::PlayerMapper
              .new(App.config.STEAM_KEY)
              .find(remote_id)

            # Add player to database
            Repository::For.entity(player).find_or_create_with_friends(player)

            # Redirect viewer to player page
            routing.redirect "player/#{player.remote_id}/game_count"
          end
        end

        routing.on String, String do |remote_id, info_value|
          # GET /player/remote_id
          routing.get do
            # Get player from database
            player = Repository::For.klass(Entity::Player).find_id(remote_id)

            # Show viewer the player
            view 'player', locals: { player:, info_value: }
          end
        end
      end
    end
  end
end
