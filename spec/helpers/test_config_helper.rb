# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'yaml'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))['test']
STEAM_KEY = CONFIG['STEAM_KEY']
STEAM_ID = CONFIG['STEAM_ID_0']
