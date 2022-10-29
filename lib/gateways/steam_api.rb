# frozen_string_literal: true

require 'httparty'
require 'json'

module SteamBuddy
  module Steam
    # Library for Steam Web API
    class Api
      def initialize(key)
        @steam_key = key
      end

      def owned_games_data(steam_id)
        Request.new(@steam_key).owned_games(steam_id)
      end

      def friend_list_data(steam_id)
        Request.new(@steam_key).friend_list(steam_id)
      end
    end

    # Sends out HTTP requests to Steam
    class Request
      API_ROOT = 'http://api.steampowered.com/'

      def initialize(key)
        @key = key
      end

      def owned_games(steam_id)
        url = st_api_path('IPlayerService/GetOwnedGames/v1')
        call_st_url(url, steam_id)['response']
      end

      def friend_list(steam_id)
        url = st_api_path('ISteamUser/GetFriendList/v1')
        call_st_url(url, steam_id)['friendslist']['friends']
      end

      def st_api_path(path)
        "#{API_ROOT}#{path}"
      end

      def call_st_url(url, steam_id)
        parameter = {
          query: {
            key: @key,
            steamid: steam_id
          }
        }
        response = HTTParty.get(url, parameter)
        JSON.parse(response.body)
      end
    end
  end
end
