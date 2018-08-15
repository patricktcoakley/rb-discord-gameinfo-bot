# frozen_string_literal: true

require 'net/http'
require 'json'

class GiantBombClient
  attr_reader :key

  def initialize(key)
    @key = key
  end

  def find_game(query)
    uri = URI('https://www.giantbomb.com/api/search/')
    params = { api_key: @key, format: 'json', resources: 'game', query: query, limit: 10, fields: 'name, original_release_date,expected_release_year,platforms,site_detail_url' }
    request_params(uri, params)
    results = response_handler(uri)
    header = "Here's what I found:\n\n"
    game_info(results, header)
  end

  def latest_games
    uri = URI('https://www.giantbomb.com/api/games/')
    params = { api_key: @key, format: 'json', filter: "original_release_date:#{last_week}|#{todays_date}", resources: 'game', limit: 10, sort: 'original_release_date:asc', fields: 'name,original_release_date,expected_release_year,platforms,site_detail_url' }
    request_params(uri, params)
    results = response_handler(uri)
    header = "Here's this week's new releases:\n\n"
    game_info(results, header)
  end

  private

  def last_week
    "#{Date.today.year}-#{Date.today.month}-#{Date.today.day - 7} 00:00:00"
  end

  def todays_date
    "#{Date.today.year}-#{Date.today.month}-#{Date.today.day} 00:00:00"
  end

  def game_info(results, header)
    games = []
    results['results'].each do |result|
      name = game_name(result)
      platforms = game_platforms(result)
      release_date = game_release(result)
      url = game_url(result)

      # Create new game object and add to list
      game = Game.new(name, platforms, release_date, url)
      games.push(game)
    end
    header + games.join(' ')
  end

  def game_name(result)
    result['name']
  end

  def game_url(result)
    result['site_detail_url'].nil? ? '' : result['site_detail_url']
  end

  def game_release(result)
    if result['original_release_date'].nil? && result['expected_release_year'].nil?
      nil
    else
      result['original_release_date'] || result['expected_release_year']
    end
  end

  def game_platforms(result)
    platforms = []
    if result['platforms'].nil?
      platforms.push('None')
      return
    else
      result['platforms'].each do |platform|
        platforms.push(platform['name'])
      end
    end
    platforms
  end

  def request_params(uri, params)
    uri.query = URI.encode_www_form(params)
    puts uri
  end

  def response_handler(uri)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end
  
  class Game
    attr_reader(:name, :platforms, :release, :url)

    def initialize(name, platforms, release, url)
      @name = name
      @platforms = platforms
      @release =
        case release
        when Integer
          "Expected #{release}"
        when String
          date = Date.parse(release)
          date.strftime('%m/%d/%Y')
        else
          'None'
        end
      @url = url
    end

    def to_s
      "\n#{@name}\nPlatforms: #{@platforms.join(', ')}\nRelease: #{@release}\nMore Info: #{@url}\n"
    end
  end
end
