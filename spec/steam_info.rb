# frozen_string_literal: true

# Steam Web API Reference: https://steamcommunity.com/dev

require_relative 'read_config'

require 'httparty'
require 'json'

# Take Steam api info
class TakeResult
  attr_reader :api, :param

  def initialize(api, param, col_name)
    @api = api
    @param = param
    @col_name = col_name
  end

  def response
    puts @api
    puts @param
    response = HTTParty.get(@api, @param)
    JSON.parse(response.body)
  end
end

friends_api = 'http://api.steampowered.com/ISteamUser/GetFriendList/v1'
owned_api = 'http://api.steampowered.com/IPlayerService/GetOwnedGames/v1'

parameter = {
  query: {
    key: STEAM_KEY,
    steamid: STEAM_ID
  }
}

tmp = TakeResult.new(friends_api, parameter, 'friends')
friends_info = tmp.response

tmp = TakeResult.new(owned_api, parameter, 'owned')
owned_info = tmp.response

st_results = {}
st_results['friends'] = friends_info['friendslist']['friends']
st_results['owned'] = owned_info

filename = 'spec/fixtures/steam_results.yml'
File.write(filename, st_results.to_yaml)
