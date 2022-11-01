# frozen_string_literal: true

require 'roda'
require 'yaml'

module SteamBuddy
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    STEAM_KEY = CONFIG['steam_key']
  end
end
