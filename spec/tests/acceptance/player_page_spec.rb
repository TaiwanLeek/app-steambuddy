# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/player_page_game_count'
require_relative 'pages/player_page_played_time'
require_relative 'pages/player_page_favorite_game'
require_relative 'pages/home_page'

describe 'Player Page Acceptance Tests' do
  include PageObject::PageFactory

  before do
    # DatabaseHelper.wipe_database
    # Headless error? https://github.com/leonid-shevtsov/headless/issues/80
    # @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    # @headless.destroy
  end

  it '(HAPPY) should see player game count content if player exists' do
    # GIVEN: user has requested and created a player
    visit HomePage do |page|
      good_id = STEAM_ID
      page.add_new_player(good_id)
    end

    # WHEN: user goes to the player game count page
    visit(PlayerPage, using_params: { remote_id: STEAM_ID,
                                      info_value: GAME_COUNT_INFO }) do |page|
      # THEN: they should see the player details
      _(page.game_count_table_element.present?).must_equal true

      playernames = ['Cherise', 'Black Parade', 'Ariel', 'a0985418957', 'Joy']
      playerids = %w[76561198326876707 76561198274628186 76561198376062883 76561198383470383
                     76561199180185538]
      _(playerids.include?(page.players0[0].player_id)).must_equal true
      _(playerids.include?(page.players0[0].friend_id)).must_equal true

      _(playernames.include?(page.players0[0].player_name)).must_equal true
      _(playernames.include?(page.players0[0].friend_name)).must_equal true

      _(page.players0[0].player_game_count.to_i).must_equal 33
      _(page.players0[0].friend_game_count.to_i).must_equal 0
    end
  end

  it '(HAPPY) should see player played time content if player exists' do
    # GIVEN: user has requested and created a player
    visit HomePage do |page|
      good_id = STEAM_ID
      page.add_new_player(good_id)
    end

    # WHEN: user goes to the player played time page
    visit(PlayerPage, using_params: { remote_id: STEAM_ID,
                                      info_value: PLAYED_TIME_INFO }) do |page|
      # THEN: they should see the player details
      _(page.played_time_table_element.present?).must_equal true

      playernames = ['Cherise', 'Black Parade', 'Ariel', 'a0985418957', 'Joy']
      playerids = %w[76561198326876707 76561198274628186 76561198376062883 76561198383470383
                     76561199180185538]
      _(playerids.include?(page.players1[0].player_id)).must_equal true
      _(playerids.include?(page.players1[0].friend_id)).must_equal true

      _(playernames.include?(page.players1[0].player_name)).must_equal true
      _(playernames.include?(page.players1[0].friend_name)).must_equal true

      _(page.players1[0].player_total_played_time.to_i).must_equal 31
      _(page.players1[0].friend_total_played_time.to_i).must_equal 0
    end
  end

  it '(HAPPY) should see player favorite game content if player exists' do
    # GIVEN: user has requested and created a player
    visit HomePage do |page|
      good_id = STEAM_ID
      page.add_new_player(good_id)
    end

    # WHEN: user goes to the player favorite game page
    visit(PlayerPage, using_params: { remote_id: STEAM_ID,
                                      info_value: FAVORITE_GAME_INFO }) do |page|
      # THEN: they should see the player details
      _(page.favorite_game_table_element.present?).must_equal true

      playernames = ['Cherise', 'Black Parade', 'Ariel', 'a0985418957', 'Joy']
      playerids = %w[76561198326876707 76561198274628186 76561198376062883 76561198383470383
                     76561199180185538]
      _(playerids.include?(page.players2[0].player_id)).must_equal true
      _(playerids.include?(page.players2[0].friend_id)).must_equal true

      _(playernames.include?(page.players2[0].player_name)).must_equal true
      _(playernames.include?(page.players2[0].friend_name)).must_equal true

      _(page.players2[0].player_favorite_game_name).must_equal 'Cyberpunk 2077'
      _(page.players2[0].friend_favorite_game_name).must_equal ''

      _(page.players2[0].player_favorite_game_played_time.to_i).must_equal 31
      _(page.players2[0].friend_favorite_game_played_time.to_i).must_equal 0
    end
  end
end
