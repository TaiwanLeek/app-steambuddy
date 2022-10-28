# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'vcr'
require 'webmock'

require_relative '../require_app'
require_app

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
STEAM_KEY = CONFIG['steam_key']
STEAM_ID = CONFIG['steam_id']
CORRECT = YAML.safe_load(File.read('spec/fixtures/steam_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'steam_api'
