# frozen_string_literal: true

require 'roda'
require 'slim'

STEAM_ID64_LENGTH = 17

module SteamBuddy
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row_click.js'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        players = Repository::For.klass(Entity::Player).all

        viewable_player = Views::PlayersList.new(players)

        view 'home', locals: { players: viewable_player }
      end

      routing.on 'player' do # rubocop:disable Metrics/BlockLength
        routing.is do
          # POST /player/
          routing.post do
            remote_id = routing.params['remote_id']
            routing.halt 400 unless remote_id &&
                                    remote_id.length == STEAM_ID64_LENGTH

            # Try getting player from database
            db_player = Repository::For.klass(Entity::Player).find_id(remote_id)
            player = Repository::For.klass(Entity::Player).find_id(db_player&.remote_id)

            unless player&.full_friend_data
              # Get player from API
              player = Steam::PlayerMapper
                .new(App.config.STEAM_KEY)
                .find(remote_id)

              # Add player to database
              Repository::For.entity(player).find_or_create_with_friends(player)
            end
            # Redirect viewer to player page
            routing.redirect "player/#{player.remote_id}"
          end
        end

        routing.on String, String do |remote_id, info_value|
          # GET /player/remote_id/info_value
          routing.get do
            # Get player from database
            player = Repository::For.klass(Entity::Player).find_id(remote_id)

            player ||= Steam::PlayerMapper
              .new(App.config.STEAM_KEY)
              .find(remote_id)

            # Show viewer the player
            view 'player', locals: { player:, info_value: }
          end
        end

        routing.on String do |remote_id|
          # GET /player/remote_id
          routing.get { routing.redirect "#{remote_id}/game_count" }
        end
      end
    end
  end
end
