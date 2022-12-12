# frozen_string_literal: true

module SteamBuddy
  module Response
    class OpenStructWithLinks < OpenStruct
      attr_accessor :links
    end
  end
end
