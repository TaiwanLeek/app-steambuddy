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
        _(page.title_heading).must_equal 'SteamBuddy'
        _(page.id_input_element.present?).must_equal true
        _(page.add_button_element.present?).must_equal true
        _(page.players_table_element.exists?).must_equal false

        _(page.success_message_element.present?).must_equal true
        _(page.success_message.downcase).must_include 'start'
      end
    end

    # it '(HAPPY) should not see players they did not request' do
    #  # GIVEN: a player exists in the database but user has not requested it
    #  player = SteamBuddy::Steam::PlayerMapper
    #    .new(STEAM_KEY).find(STEAM_ID)
    #  SteamBuddy::Repository::For.entity(player).create(player)
    #
    #  # WHEN: user goes to the homepage
    #  visit HomePage do |page|
    #    # THEN: they should not see any players
    #    _(page.players_table_element.exists?).must_equal false
    #  end
    # end
  end

  describe 'Add Player' do
    it '(HAPPY) should be able to request a player' do
      # GIVEN: user is on the home page without any players
      visit HomePage do |page|
        # WHEN: they add a player URL and submit
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
        # THEN: they should see their player's details listed
        _(page.players_table_element.exists?).must_equal true
        _(page.num_players).must_equal 1
        _(page.first_player.text).must_include STEAM_ID
        _(page.first_player.text).must_include USERNAME
      end
    end

    it '(HAPPY) should see player highlighted when they hover over it' do
      # GIVEN: user has requested a player to watch
      good_id = STEAM_ID
      visit HomePage do |page|
        page.add_new_player(good_id)
      end

      # WHEN: they go to the home page
      visit HomePage do |page|
        # WHEN: ..and hover over their new player
        page.first_player_hover

        # THEN: the new player should not get highlighted
        # Because we don't have hyperlink
        _(page.first_player_highlighted?).must_equal false
      end
    end

    it '(BAD) should not be able to add an invalid player URL' do
      # GIVEN: user is on the home page without any players
      visit HomePage do |page|
        # WHEN: they request a player with an invalid URL
        bad_id = 'foobar'
        page.add_new_player(bad_id)

        # THEN: they should see a warning message
        _(page.warning_message.downcase).must_include 'invalid'
      end
    end

    it '(SAD) should not be able to add valid but non-existent player ID' do
      # GIVEN: user is on the home page without any players
      visit HomePage do |page|
        # WHEN: they add a player ID that is valid but non-existent
        sad_id = '12345678912345678'
        page.add_new_player(sad_id)

        # THEN: they should see a warning message
        _(page.warning_message.downcase).must_include 'could not find'
      end
    end
  end

  describe 'Delete Player' do
    it '(HAPPY) should be able to delete a requested player' do
      # GIVEN: user has requested and created a player
      visit HomePage do |page|
        good_id = STEAM_ID
        page.add_new_player(good_id)
      end

      # WHEN: they revisit the homepage and delete the player
      visit HomePage do |page|
        page.first_player_delete

        # THEN: they should not find any players
        _(page.players_table_element.exists?).must_equal false
      end
    end
  end
end
