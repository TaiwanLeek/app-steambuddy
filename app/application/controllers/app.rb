# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module SteamBuddy
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # allows DELETE and other HTTP verbs beyond GET/POST
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row.js'
    plugin :caching
    plugin :common_logger, $stderr

    use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        session[:players_watching] ||= []

        result = Service::ListPlayers.new.call(session[:players_watching])

        if result.failure?
          flash[:error] = result.failure
          viewable_players = []
        else
          players = result.value!.players
          flash.now[:notice] = 'Add a Steam ID to get started' if players.none?

          viewable_players = Views::PlayersList.new(players).filter(session[:players_watching])
        end

        App.configure :production do
          response.expires 60, public: true
        end
        view 'home', locals: { players: viewable_players }
      end

      routing.on 'player' do
        routing.is do
          # POST /player/
          routing.post do
            id_request = Forms::NewPlayer.new.call(routing.params) #  output: <Dry::Validation::Result:0x00007f4658035db8>
            id_checkpoint = Service::AddPlayerCheck.new.call(id_request)
            if id_checkpoint.failure?
              flash[:error] = id_checkpoint.failure
              routing.redirect '/'
            end

            player_made = Service::AddPlayer.new.call(id_checkpoint.value!)

            if player_made.failure?
              flash[:error] = player_made.failure
              routing.redirect '/'
            end

            player = player_made.value!

            # Add player and player's friends remote_id to session
            session[:players_watching].insert(0, player.remote_id).uniq!
            flash[:notice] = 'player added to your list!'

            # Add friend list into session
            # player&.friend_list&.each { |friend| session[:players_watching].insert(0, friend.remote_id).uniq! }

            # Redirect viewer to player page
            routing.redirect "player/#{player.remote_id}"
          end
        end

        routing.on String, String do |remote_id, info_value|
          # GET /player/remote_id/info_value
          routing.get do
            player_result = Service::GetTable.new.call(
              remote_id:,
              info_value:
            )

            player = player_result.value!
            viewable_player = Views::Player.new(player)

            # Show viewer the player
            view 'player', locals: { player: viewable_player, info_value: }
          end
        end

        # This route has to be placed AFTER |player, info_value|
        routing.on String do |remote_id|
          # DELETE /player/remote_id
          routing.delete do
            fullname = remote_id.to_s
            session[:players_watching].delete(fullname)

            routing.redirect '/'
          end

          # GET /player/remote_id
          routing.get do
            path_request = PlayerRequestPath.new(
              remote_id, request
            )

            session[:players_watching] ||= []
            routing.redirect "#{remote_id}/game_count"
          end
        end
      end
    end
  end
end
