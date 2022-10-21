# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'vcr'
require 'webmock'

require_relative '../lib/steam_api'


CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
STEAM_KEY = CONFIG['key']
STEAM_ID = CONFIG['steamid']
CORRECT = YAML.safe_load(File.read('spec/fixtures/steam_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'github_api'