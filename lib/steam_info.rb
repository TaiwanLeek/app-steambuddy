# frozen_string_literal: true

# Steam Web API Reference: https://steamcommunity.com/dev

require 'httparty'
require 'yaml'
require 'json'

st_results = {}

config = YAML.safe_load(File.read('config/secrets.yml'))

friends_api = 'http://api.steampowered.com/ISteamUser/GetFriendList/v1'
parameter = {
  query: {
    key: config['key'],
    steamid: config['steamid']
  }
}

response = HTTParty.get(friends_api, parameter)
st_results['friends'] = JSON.parse(response.body)['friendslist']['friends']

owned_api = 'http://api.steampowered.com/IPlayerService/GetOwnedGames/v1'
parameter = {
  query: {
    key: config['key'],
    steamid: config['steamid']
  }
}

response = HTTParty.get(owned_api, parameter)
st_results['owned'] = JSON.parse(response.body)

filename = 'spec/fixtures/steam_results.yml'
File.open(filename, 'w+') do |f|
  f.write(st_results.to_yaml)
end
