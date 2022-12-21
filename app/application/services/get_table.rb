# frozen_string_literal: true

require 'dry/transaction'

module SteamBuddy
  module Service
    # Transaction to get player info table accordin to info_value

    # Author: a0985
    class GetTable
      include Dry::Transaction

      step :request_player
      step :friend_sort

      private

      def request_player(input)
        player_made = Service::AddPlayer.new.call(input)
        player = player_made.value!

        input[:player_info] = player
        Success(input)
      rescue StandardError
        Failure('Having trouble to find player')
      end

      def friend_sort(input)
        Service::DataHelper.friend_sort!(input[:player_info], input[:info_value])
        player = input[:player_info]
        Success(player)
      rescue StandardError => e
        Logger.error e.backtrace.join("\n")
        Failure('Table accessing has some error')
      end
    end
  end
end
