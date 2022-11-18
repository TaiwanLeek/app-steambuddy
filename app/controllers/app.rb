# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

STEAM_ID64_LENGTH = 17

module SteamBuddy
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    # plugin :all_verbs # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row.js'
    plugin :common_logger, $stderr

    # use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        session[:watching] ||= []
        players = Repository::For.klass(Entity::Player).all

        flash.now[:notice] = 'Add a Steam ID to get started' if players.none?

        viewable_players = Views::PlayersList.new(players).filter(session[:watching])

        view 'home', locals: { players: viewable_players }
      end

      routing.on 'player' do # rubocop:disable Metrics/BlockLength
        routing.is do
          # POST /player/
          routing.post do
            remote_id = routing.params['remote_id']

            unless remote_id &&
                   remote_id.length == STEAM_ID64_LENGTH
              flash[:error] = 'Invalid Steam ID!'
              response.status = 400
              routing.redirect '/'
            end

            # Try getting player from database
            db_player = Repository::For.klass(Entity::Player).find_id(remote_id)
            player = Repository::For.klass(Entity::Player).find_id(db_player&.remote_id)

            unless player&.full_friend_data
              # Get player from API
              begin
                player = Steam::PlayerMapper
                  .new(App.config.STEAM_KEY)
                  .find(remote_id)
              rescue StandardError
                flash[:error] = 'Could not find player friends'
              end

              # Add player to database
              begin
                Repository::For.entity(player).find_or_create_with_friends(player)
              rescue StandardError => e
                Logger.error e.backtrace.join("\n")
                flash[:error] = 'Having trouble accessing the database'
              end
            end

            # Add player and player's friends remote_id to session
            session[:watching].insert(0, player.remote_id).uniq!
            player&.friend_list&.each { |friend| session[:watching].insert(0, friend.remote_id).uniq! }

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

            Steam::PlayerMapper::DataHelper.friend_sort!(player, info_value)

            viewable_player = Views::Player.new(player)

            # Show viewer the player
            view 'player', locals: { player: viewable_player, info_value: }
          end
        end

        # This route has to be placed AFTER |remote_id, info_value|
        routing.on String do |remote_id|
          # GET /player/remote_id
          routing.get { routing.redirect "#{remote_id}/game_count" }
        end
      end
    end
  end
end
