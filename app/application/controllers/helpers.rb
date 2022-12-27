# frozen_string_literal: true

module SteamBuddy
  module RouteHelpers
    # Application value for the path of a requested project
    class PlayerRequestPath
      def initialize(remote_id, request)
        @remote_id = remote_id
        @request = request
        @path = request.remaining_path
      end

      attr_reader :remote_id

      def folder_name
        @folder_name ||= @path.empty? ? '' : @path[1..]
      end

      def player_fullname
        @request.captures.join '/'
      end
    end
  end
end
