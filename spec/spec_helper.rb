# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

STEAM_ID = '76561198326876707'
USERNAME = 'Cherise'
CORRECT = YAML.safe_load(File.read('spec/fixtures/steam_results.yml'))
