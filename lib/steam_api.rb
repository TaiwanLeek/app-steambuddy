# frozen_string_literal: true

require 'httparty'
require_relative 'friends'
require_relative 'owned_games'

module SteamCircle
  class SteamApi
    API_ROOT = 'http://api.steampowered.com/'

    def initialize(key)
      @st_key = key
    end

    def friends(steamid)
      url = st_api_path('ISteamUser/GetFriendList/v1')
      friend_data = call_st_url(url, steamid)['friendslist']['friends']
      Friends.new(friend_data)
    end

    def owned_games(steamid)
      url = st_api_path('IPlayerService/GetOwnedGames/v1')
      games_data = call_st_url(url, steamid)['response']
      OwnedGames.new(games_data['game_count'], games_data['games'])
    end

    private

    def st_api_path(path)
      "#{API_ROOT}/#{path}"
    end

    def call_st_url(url, steamid)
      parameter = {
        query: {
          key: @st_key,
          steamid: steamid
        }
      }
      response = HTTParty.get(url, parameter)
      JSON.parse(response.body)
    end
  end
end
