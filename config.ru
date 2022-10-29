# frozen_string_literal: true

require_relative 'require_app'
require_app

run SteamBuddy::App.freeze.app
