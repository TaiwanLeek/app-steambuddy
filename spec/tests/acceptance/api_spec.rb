# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require 'rack/test'

def app
  SteamBuddy::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end
end
