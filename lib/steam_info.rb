# frozen_string_literal: true

# Steam Web API Reference: https://steamcommunity.com/dev

require 'httparty'
require 'yaml'
require 'json'

$st_results = {}

def take_st_result(api, param, col_name)
  response = HTTParty.get(api, param)

  if col_name == 'firends'
    $st_results['friends'] = JSON.parse(response.body)['friendslist']['friends']
  else
    $st_results['owned'] = JSON.parse(response.body)
  end
end

config = YAML.safe_load(File.read('config/secrets.yml'))

friends_api = 'http://api.steampowered.com/ISteamUser/GetFriendList/v1'
owned_api = 'http://api.steampowered.com/IPlayerService/GetOwnedGames/v1'

parameter = {
  query: {
    key: config['key'],
    steamid: config['steamid']
  }
}

take_st_result(friends_api, parameter, 'friends')
take_st_result(owned_api, parameter, 'owned')


filename = 'spec/fixtures/steam_results.yml'
File.open(filename, 'w+') do |f|
  f.write($st_results.to_yaml)
end
