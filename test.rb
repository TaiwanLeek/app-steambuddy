# frozen_string_literal: true

require_relative 'require_app'
require_app

require_relative 'config/environment'

SteamBuddy::App.new('0')
