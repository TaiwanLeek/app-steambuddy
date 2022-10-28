# frozen_string_literal: true

require 'yaml'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
STEAM_KEY = CONFIG['steam_key']
STEAM_ID = CONFIG['steam_id_0']
