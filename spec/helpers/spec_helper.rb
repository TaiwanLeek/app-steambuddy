# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

require_relative '../../require_app'
require_app

USERNAME = 'Cherise'
STEAM_KEY = 'C450FFC18AD99BD334178BF3546E8CD5'
STEAM_ID = '76561198326876707'
GAME_COUNT_INFO = 'game_count'
PLAYED_TIME_INFO = 'played_time'
FAVORITE_GAME_INFO = 'favorite_game'
# Helper method for acceptance tests
def homepage
  SteamBuddy::App.config.APP_HOST
end
