# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'

describe 'Homepage Acceptance Tests' do
  include PageObject::PageFactory

  before do
    # DatabaseHelper.wipe_database
    # Headless error? http://0.0.0.0:9000/player/76561198326876707/game_count
    # Headless error? https://github.com/leonid-shevtsov/headless/issues/80
    # @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Visit Home page' do
    it '(HAPPY) should not see players if none created' do
      # GIVEN: null players
      # WHEN: they visit the home page
      visit HomePage do |page|
        # THEN: they should see basic headers, no players and a welcome message
        _(page.title_heading).must_equal 'SteamBuddy ヾ(*´∀ `*)ﾉ'
        _(page.id_input_element.present?).must_equal true
        _(page.add_button_element.present?).must_equal true
        _(page.players_table_element.exists?).must_equal false

        _(page.success_message_element.present?).must_equal true
        _(page.success_message.downcase).must_include 'start'
      end
    end

    it '(HAPPY) should not see players they did not request' do
      # GIVEN: a player exists in the database but user has not requested it
      project = SteamBuddy::Steam::PlayerMapper
        .new(STEAM_KEY).find(STEAM_ID)
      SteamBuddy::Repository::For.entity(player).create(player)

      # WHEN: user goes to the homepage
      visit HomePage do |page|
        # THEN: they should not see any players
        _(page.players_table_element.exists?).must_equal false
      end
    end
  end

  describe 'Add Player' do
    it '(HAPPY) should be able to request a player' do
      # GIVEN: user is on the home page without any projects
      visit HomePage do |page|
        # WHEN: they add a project URL and submit
        good_id = STEAM_ID
        page.add_new_player(good_id)

        # THEN: they should find themselves on the player's page
        @browser.url.include? STEAM_ID
      end
    end

    it '(HAPPY) should be able to see requested players listed' do
      # GIVEN: user has requested a player
      visit HomePage do |page|
        good_id = STEAM_ID
        page.add_new_player(good_id)
      end

      # WHEN: they return to the home page
      visit HomePage do |page|
        # THEN: they should see their project's details listed
        _(page.players_table_element.exists?).must_equal true
        _(page.num_players).must_equal 1
        _(page.first_player.text).must_include STEAM_ID
        _(page.first_player.text).must_include USERNAME
      end
    end
  end
end
