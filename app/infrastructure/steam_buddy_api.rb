# frozen_string_literal: true

require 'http'

module SteamBuddy
  module Gateway
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def players_list(list)
        @request.players_list(list)
      end
    end

    class Request
      def initialize(config)
        @api_host = config.API_HOST
        @api_root = "#{@api_host}/api/v1"
      end

      def get_root
        call_api('get')
      end

      def players_list(list)
        call_api('get', ['players'],
                 'list' => Value::WatchedList.to_encoded(list))
      end

      private

      def params_str(params)
        params.map { |key, value| "#{key}=#{value}" }.join('&')
          .then { |str| str ? '?' + str : '' }
      end

      def call_api(method, resources = [], params = {})
        api_path = resources.empty? ? @api_host : @api_root
        url = [api_path, resources].flatten.join('/') + params_str(params)
        HTTP.headers('Accept' => 'application/json').send(method, url)
          .then { |http_response| Response.new(http_response) }
      rescue StandardError
        raise "Invalid URL request: #{url}"
      end
    end

    class Response < SimpleDelegator
      NotFound = Class.new(StandardError)

      SUCCESS_CODES = (200..299)

      def success?
        code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
      end

      def message
        payload['message']
      end

      def payload
        body.to_s
      end
    end
  end
end
