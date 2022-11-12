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

      def personaname(steam_id)
        Request.new(@steam_key).personaname(steam_id)
      end

      def owned_games_data(steam_id)
        Request.new(@steam_key).owned_games(steam_id)
      end

      def friend_list_data(steam_id)
        Request.new(@steam_key).friend_list(steam_id)
      end

      def game_name(appid)
        url = 'https://store.steampowered.com/api/appdetails'
        parameter = {
          query: {
            appids: appid
          }
        }
        response = HTTParty.get(url, parameter)
        body = JSON.parse(response.body)
        game_body = body[appid.to_s] if body
        game_body['data']['name'] if game_body && game_body['success']
      end
    end

    # Sends out HTTP requests to Steam
    class Request
      API_ROOT = 'http://api.steampowered.com/'

      def initialize(key)
        @key = key
      end

      def game_name(_appid)
        url = st_api_path('IPlayerService/GetOwnedGames/v1')
        call_steam_url(url, steam_id)['response']
      end

      def owned_games(steam_id)
        url = st_api_path('IPlayerService/GetOwnedGames/v1')
        call_steam_url(url, steam_id)['response']
      end

      def friend_list(steam_id)
        url = st_api_path('ISteamUser/GetFriendList/v1')
        friend_list = call_steam_url(url, steam_id)['friendslist']
        friend_list['friends'] if friend_list
      end

      def personaname(steam_id)
        url = st_api_path('ISteamUser/GetPlayerSummaries/v2')
        call_steam_url_with_steam_ids(url, steam_id)['response']['players'][0]['personaname']
      end

      def st_api_path(path)
        "#{API_ROOT}#{path}"
      end

      def call_steam_url(url, steam_id)
        parameter = {
          query: {
            key: @key,
            steamid: steam_id
          }
        }
        response = HTTParty.get(url, parameter)
        JSON.parse(response.body)
      end

      def call_steam_url_with_steam_ids(url, steam_ids)
        parameter = {
          query: {
            key: @key,
            steamids: steam_ids
          }
        }
        response = HTTParty.get(url, parameter)
        JSON.parse(response.body)
      end
    end
  end
end
