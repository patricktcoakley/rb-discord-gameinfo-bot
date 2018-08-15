#!/usr/bin/ruby
# frozen_string_literal: true

require './giant_bomb_client'
require './news_reader'
require 'yaml'
require 'discordrb'

settings = YAML.load_file('settings.yaml').freeze

gb = GiantBombClient.new(settings[:giant_bomb_api_key])

bot = Discordrb::Commands::CommandBot.new(
  token: settings[:discord_token],
  client_id: settings[:discord_client_id],
  prefix: settings[:prefix]
)

bot.command :latest do |_|
  gb.latest_games
end

bot.command :find do |_, *arguments|
  gb.find_game(arguments.join(' '))
end

bot.command :news do |_, argument = 'gematsu'|
  NewsReader.news(argument)
end

bot.command :echo do |_, *arguments|
  arguments.join(' ')
end

bot.run