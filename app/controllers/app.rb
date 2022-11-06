# frozen_string_literal: true

require 'roda'
require 'slim'

STEAM_ID64_LENGTH = 17

module SteamBuddy
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        users = Repository::For.klass(Entity::User).all
        view 'home', locals: { users: }
      end

      routing.on 'user' do
        routing.is do
          # POST /user/
          routing.post do
            steam_id64 = routing.params['steam_id64']
            routing.halt 400 unless steam_id64 &&
                                    steam_id64.length == STEAM_ID64_LENGTH

            # Get user from Steam
            user = Steam::UserMapper
              .new(App.config.STEAM_KEY)
              .find(steam_id64)

            # Add user to database
            Repository::For.entity(user).create(user)

            # Redirect viewer to user page
            routing.redirect "user/#{user.steam_id64}"
          end
        end

        routing.on String do |steam_id64|
          # GET /user/steam_id64
          routing.get do
            # Get user from database
            user = Repository::For.klass(Entity::User).find_id(steam_id64)

            # Show viewer the user
            view 'user', locals: { user: }
          end
        end
      end
    end
  end
end
